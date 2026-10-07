output "load_balancer_dns_name" {
  description = "AWS DNS name assigned to the application load balancer."
  value       = aws_lb.application.dns_name
}

output "application_url" {
  description = "HTTP demo URL or HTTPS URL when an ACM certificate is configured."
  value       = var.certificate_arn == null ? "http://${aws_lb.application.dns_name}" : "https://${var.domain_name}"
}

output "target_group_arn" {
  description = "Application target group ARN."
  value       = aws_lb_target_group.application.arn
}

output "autoscaling_group_name" {
  description = "Application Auto Scaling Group name."
  value       = aws_autoscaling_group.application.name
}
