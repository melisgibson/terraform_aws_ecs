# ---elb/module/outputs.tf---

output "alb_listener_arn" {
  value = aws_lb_listener.http_listener.arn
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.tg.arn
}