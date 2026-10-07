data "aws_iam_policy_document" "github_trust" {
  statement {
    sid     = "GitHubActionsMainBranch"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repository}:ref:refs/heads/${var.github_branch}"]
    }
  }
}

data "aws_iam_policy_document" "ecr_publish" {
  statement {
    sid       = "GetEcrAuthorizationToken"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "PublishImagesToProjectRepository"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
    resources = [aws_ecr_repository.application.arn]
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "application_rollout" {
  statement {
    sid       = "SendOnlyTheApplicationRestartDocument"
    effect    = "Allow"
    actions   = ["ssm:SendCommand"]
    resources = [aws_ssm_document.application_restart.arn]
  }

  statement {
    sid       = "RestartOnlyTaggedApplicationInstances"
    effect    = "Allow"
    actions   = ["ssm:SendCommand"]
    resources = ["arn:aws:ec2:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:instance/*"]

    condition {
      test     = "StringEquals"
      variable = "ssm:resourceTag/Name"
      values   = ["${var.project_name}-${var.environment}-app"]
    }
  }

  statement {
    sid       = "FindRunningApplicationInstances"
    effect    = "Allow"
    actions   = ["ec2:DescribeInstances"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = [data.aws_region.current.region]
    }
  }

  statement {
    sid       = "ReadRolloutCommandStatus"
    effect    = "Allow"
    actions   = ["ssm:ListCommandInvocations"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = [data.aws_region.current.region]
    }
  }
}

resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

resource "aws_iam_role" "github_actions" {
  name                 = "${var.project_name}-${var.environment}-github-actions"
  assume_role_policy   = data.aws_iam_policy_document.github_trust.json
  description          = "Short-lived GitHub Actions role for ECR publishing and scoped application rollout."
  max_session_duration = 3600
}

resource "aws_iam_role_policy" "ecr_publish" {
  name   = "publish-to-${aws_ecr_repository.application.name}"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.ecr_publish.json
}

resource "aws_iam_role_policy" "application_rollout" {
  name   = "restart-${var.project_name}-${var.environment}-app"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.application_rollout.json
}

resource "aws_ssm_document" "application_restart" {
  name            = "${var.project_name}-${var.environment}-restart-application"
  document_type   = "Command"
  document_format = "JSON"
  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Restart the access portal container and wait for its local health endpoint."
    mainSteps = [{
      action = "aws:runShellScript"
      name   = "restartAndCheckApplication"
      inputs = {
        runCommand = [
          <<-EOT
          set -euo pipefail
          systemctl restart access-portal
          for attempt in $(seq 1 60); do
            if curl --fail --silent http://127.0.0.1:8080/actuator/health >/dev/null; then
              sleep 65
              exit 0
            fi
            sleep 5
          done
          echo 'Application health check timed out.' >&2
          exit 1
          EOT
        ]
      }
    }]
  })
}

resource "aws_ecr_repository" "application" {
  name                 = "${var.project_name}-${var.environment}"
  image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION"

  image_tag_mutability_exclusion_filter {
    filter      = "latest"
    filter_type = "WILDCARD"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}
