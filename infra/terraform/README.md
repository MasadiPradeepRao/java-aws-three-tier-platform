# AWS application foundation

This Terraform root builds a three-tier AWS foundation in two Availability Zones:

- Public subnets host an internet-facing Application Load Balancer.
- Private application subnets host an EC2 Auto Scaling Group. Instances have no public IPs, use encrypted root volumes and require IMDSv2. Systems Manager access is enabled through an instance role; SSH is not opened.
- Isolated data subnets host an encrypted, private Amazon RDS for MySQL 8.4 instance. Its password is generated and managed by RDS in Secrets Manager.
- GitHub Actions can assume a narrowly scoped AWS role with OIDC to publish the already-scanned image to an immutable-tag Amazon ECR repository. No long-lived AWS access keys are stored in GitHub.

Security groups restrict the path to browser -> ALB -> application -> database. The app tier accepts port 8080 only from the ALB, and MySQL accepts port 3306 only from the app tier. A target group checks `/actuator/health`.

## Deployment stages and transport security

The Auto Scaling Group defaults to zero instances. Its launch template installs Docker, retrieves the dedicated application database secret through the EC2 role, and starts the latest ECR image. Set `app_desired_capacity` above zero only after the app database user has been created and the secret value has been stored; otherwise the instance cannot start the app and the ALB target stays unhealthy.

Without `acm_certificate_arn`, the ALB exposes HTTP on port 80 for a disposable demonstration only. HTTP does not protect login credentials in transit, so do not enter real credentials. For HTTPS, create and validate an ACM certificate in the same region as this stack (`eu-north-1` by default), set both `acm_certificate_arn` and `application_domain_name` in `terraform.tfvars`, and create a DNS alias/CNAME that points your domain at the ALB. The configuration will add a TLS listener and redirect HTTP to HTTPS.

RDS's generated master password is not put in Terraform variables or granted to EC2. Terraform creates an empty Secrets Manager secret for application database users, but does not create a secret value or place credentials in state. Before starting the app tier, create `portal_app` and `portal_migrator` from a MySQL client running inside the VPC, using the master secret only for this one-time administrative operation. Use the example grants in `modules/database/bootstrap_application_user.sql.example`, with different long random passwords. The app account has CRUD access to the authentication tables; Flyway uses the separate schema-scoped migration account. Store matching JSON in the `database_application_secret_arn` secret:

```json
{"username":"portal_app","password":"<app password>","migrationUsername":"portal_migrator","migrationPassword":"<migration password>"}
```

Keep the RDS master secret private and never grant it to EC2. The EC2 role can read only the application secret and pull only this project's ECR repository. At startup, a root-owned helper writes the app and migration credentials to a mode-0600 environment file, logs in to ECR, and runs the `latest` image. MySQL connections require TLS encryption. The application secret is configured for immediate deletion when the disposable demo stack is destroyed.

To provision the app database users while RDS is private, launch a temporary Amazon Linux instance in one of the app subnets with the `application_instance_profile_name` profile and `app_security_group_id` security group, with no public IP. Use AWS Systems Manager port forwarding from your workstation to `database_hostname` on port 3306 (local port 3307), then connect with a local MySQL client as the master user and run the example SQL. Store matching JSON in `secrets/access-portal-db.json` (the `secrets/` folder is ignored by Git), then run:

```bash
aws secretsmanager put-secret-value \
  --secret-id "$(terraform output -raw database_application_secret_arn)" \
  --secret-string file://secrets/access-portal-db.json
```

Terminate the temporary instance after setup. Do not scale the ASG above zero until the app secret has a value.

## Cost and data lifecycle

This is a learning environment, not a free or zero-cost deployment. The ALB, RDS instance, NAT Gateway, and public IPv4 addresses can incur charges even while the Auto Scaling Group has zero instances. The defaults use one NAT Gateway and a Single-AZ database to limit fixed cost. One NAT Gateway creates an AZ dependency; production should use resilient egress and a Multi-AZ database where the availability requirement justifies the cost.

The database is deliberately configured for a disposable demo: deletion protection is off and Terraform skips the final snapshot on destroy. Export or snapshot data before removing a stack if it matters. Review the AWS cost estimate before applying and destroy resources when finished.

## Prerequisites

- Terraform 1.9 or newer
- AWS CLI configured with a least-privilege identity
- Permission to create the network, load balancer, IAM roles and policies, EC2 launch template and Auto Scaling Group, RDS, and Secrets Manager resources
- Permission to create an IAM OIDC provider, IAM role and policy, and ECR repository
- Optional: a validated ACM certificate in the selected region for HTTPS

## Plan and apply

From this directory:

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Review every plan before applying. Terraform uses local state in this learning step. Do not commit `.terraform/`, `terraform.tfstate*`, `tfplan`, or real `terraform.tfvars` files. Configure protected remote state before using this collaboratively or from CI.

After applying, copy the `github_actions_role_arn` and `ecr_repository_url` outputs into GitHub repository **Actions variables** named `AWS_ROLE_ARN` and `ECR_REPOSITORY_URI`; set `AWS_REGION` to the same region used by Terraform. These are identifiers, not secrets. The ECR workflow is skipped until all three variables exist. The role trust policy accepts only the configured repository and branch. If the AWS account already has the GitHub Actions OIDC provider, import that provider into Terraform state before applying instead of attempting to create a duplicate.

The ECR workflow publishes the same image tarball that passed the CI vulnerability scan, tagged with the full source commit SHA and `latest`. Commit tags cannot be overwritten; `latest` is the only mutable tag and is used when new EC2 instances start. Existing instances do not automatically restart when a new image is published; rolling deployment is a separate follow-up milestone. The existing GHCR publication remains unchanged. The ASG remains at zero until you set a desired capacity after database-secret setup; scale it back to zero when finished to reduce compute charges.

## Tear down

When finished, review the destroy plan and then run:

```bash
terraform destroy
```

This deletes the demo database without a final snapshot. NAT Gateways and public IPv4 addresses can continue to incur charges until removed.
