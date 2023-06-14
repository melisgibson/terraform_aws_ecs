# ---elb/module/outputs.tf---

output "alb_listener_arn" {
  value = aws_lb_listener.https_listener.arn
}