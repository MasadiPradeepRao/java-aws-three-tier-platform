# Portfolio evidence checklist

Capture evidence from a real deployment after reviewing and applying the Terraform plan. Do not imply that AWS resources or workflows ran if they were only configured in code.

## Suggested screenshots

- GitHub Actions: successful verification, image scan, publish, and rollout jobs.
- Commit history: the incremental implementation milestones and useful commit messages.
- Terraform plan: resource changes, with account IDs and sensitive values obscured.
- AWS console: the VPC subnet tiers and security-group paths.
- ECR: immutable `sha-...` release tags and image scan status.
- EC2 and Systems Manager: private application instances and a successful restart command.
- Load Balancer: target health and the application health endpoint.
- RDS and Secrets Manager: private database configuration; never capture secret values.
- CloudWatch and Budgets: alarm definitions, confirmed email subscription, and cost notifications.

## Before sharing

- Redact AWS account IDs, personal email addresses, public IPs, domains, and any credentials or secret values.
- Use a disposable test account and test credentials for login screenshots.
- Label screenshots with the date and whether they show a plan, configuration, or deployed runtime.
- Remove screenshots that expose customer or unrelated account resources.
