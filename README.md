# Java Login on AWS: Three-Tier Portfolio Project

An independent, hands-on implementation of a Java application deployed on AWS. The project is being built incrementally to demonstrate application delivery, infrastructure as code, CI/CD, security, and operations.

## Inspiration and attribution

This project uses the Java login application and three-tier deployment exercise in [NotHarshhaa/DevOps-Projects, Project 1](https://github.com/NotHarshhaa/DevOps-Projects/tree/master/DevOps-Project-01) as a learning reference. The implementation, architecture decisions, improvements, and documentation in this repository are being developed and explained as part of this portfolio project. Original source and dependencies retain their respective licenses.

## Current status

This repository is under active development. The application scaffold is being prepared first; infrastructure and delivery automation will be added in later milestones. Deployment instructions will be added after each part is implemented and verified.

## Planned milestones

1. Establish an attributed, credential-safe application baseline.
2. Improve application configuration, database access, and password handling.
3. Add local development dependencies and repeatable application checks.
4. Refactor Terraform networking and remove unsafe defaults.
5. Add container packaging and image scanning.
6. Build a CI pipeline for tests, quality checks, and artifact creation.
7. Add AWS deployment automation with short-lived GitHub OIDC credentials.
8. Add operational visibility, runbooks, and teardown guidance.
9. Document the final architecture, decisions, evidence, and limitations.

## Security

Never commit AWS credentials, database passwords, access tokens, Terraform state, or generated environment files. Use environment variables or a managed secret store for runtime configuration. Review the project before deploying to an AWS account and destroy demonstration resources when they are no longer needed.

