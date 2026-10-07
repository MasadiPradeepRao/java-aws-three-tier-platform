# AWS network foundation

This Terraform root creates a VPC with public, application-private, and data-private subnets across two Availability Zones. Public subnets route through an Internet Gateway; application subnets use NAT for outbound connections; data subnets have no internet route. Security groups allow HTTP to the load balancer, port 8080 from the load balancer to the app, MySQL from the app to the database, and outbound HTTPS from the app tier.

## Cost and availability choice

The default `nat_gateway_strategy = "single"` creates one NAT Gateway to keep this learning environment's fixed networking costs lower. It introduces an Availability Zone dependency and cross-AZ traffic for the other application subnet. Set it to `"per_az"` for one NAT Gateway in each AZ; that improves AZ-local egress resilience but increases cost. NAT Gateways are billable while provisioned. Review the AWS estimate before applying and destroy the environment when finished.

The database subnets are isolated from internet routes. No SSH ingress is configured. HTTPS is the current outbound allowance for application instances; a later step can replace broad egress with specific VPC endpoints where practical.

## Prerequisites

- Terraform 1.9 or newer
- AWS CLI configured with a least-privilege identity for the resources in this project
- An AWS account and permission to create VPC, route, subnet, Elastic IP, NAT Gateway, and security group resources

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

Review the plan before applying. Terraform uses local state in this learning step. Do not commit `.terraform/`, `terraform.tfstate*`, `tfplan`, or real `terraform.tfvars` files. A later step will configure protected remote state before this is used collaboratively.

## Tear down

When you have finished using the environment:

```bash
terraform destroy
```

Confirm the destroy plan before approving it. NAT Gateways and their public IPv4 addresses can continue to incur charges until removed.
