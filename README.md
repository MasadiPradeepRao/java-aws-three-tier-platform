# Java Login on AWS: Three-Tier Portfolio Project

An independent, hands-on implementation of a Java application deployed on AWS. The project is being built incrementally to demonstrate application delivery, infrastructure as code, CI/CD, security, and operations.

## Inspiration and attribution

This is an independently authored application and deployment platform, inspired by the Java login and three-tier AWS exercise in [NotHarshhaa/DevOps-Projects, Project 1](https://github.com/NotHarshhaa/DevOps-Projects/tree/master/DevOps-Project-01). The app implementation in this repository is a fresh rewrite; the reference is credited for the learning direction and architecture idea.

## Current status

This repository is under active development. The app is now an independently written Spring Boot service with Spring Security sign-in, BCrypt password hashes, JDBC-backed users, a Flyway-managed MySQL schema, and environment-based database configuration. Infrastructure and delivery automation will follow. Setup instructions will be added as each part is implemented and verified.

## Planned milestones

1. Establish the independent repository and document its inspiration.
2. Build the original Java access portal with secure database-backed sign-in.
3. Add a reproducible local MySQL environment and run instructions.
4. Create the AWS network and least-privilege security boundaries in Terraform.
5. Provision the application tier, load balancer, and private database.
6. Package the application with Docker and add image security checks.
7. Add Maven CI, code-quality analysis, and artifact publishing.
8. Deploy through short-lived GitHub OIDC credentials and a documented release flow.
9. Add monitoring, cost controls, teardown instructions, and portfolio evidence.

## Security

Never commit AWS credentials, database passwords, access tokens, Terraform state, or generated environment files. Use environment variables or a managed secret store for runtime configuration. Review the project before deploying to an AWS account and destroy demonstration resources when they are no longer needed.
