resource "aws_lb_listener" "this" {
  load_balancer_arn = var.load_balancer.arn
  port              = var.port
  protocol          = var.protocol
  certificate_arn   = var.certificate.arn

  dynamic "default_action" {
    for_each = var.actions
    content {
      order            = default_action.key
      type             = default_action.value.type
      target_group_arn = default_action.value.type == "forward" ? default_action.value.target_group_arn : null

      dynamic "redirect" {
        for_each = default_action.value.redirect_options[*]
        content {
          host        = redirect.value.host
          path        = redirect.value.path
          port        = redirect.value.port
          protocol    = redirect.value.protocol
          query       = redirect.value.query
          status_code = redirect.value.status_code
        }
      }
    }
  }
}

resource "aws_lb_listener_rule" "this" {
  for_each     = var.rules
  priority     = each.key
  listener_arn = aws_lb_listener.this.arn

  action {
    type = each.value.type

    dynamic "redirect" {
      for_each = each.value.redirect_options[*]
      content {
        host        = redirect.value.host
        path        = redirect.value.path
        port        = redirect.value.port
        protocol    = redirect.value.protocol
        query       = redirect.value.query
        status_code = redirect.value.status_code
      }
    }
  }

  dynamic "condition" {
    for_each = each.value.conditions
    content {

      dynamic "host_header" {
        for_each = condition.value.host_header != null ? { 0 = condition.value.host_header } : {}
        content {
          values = condition.value.host_header
        }
      }
    }
  }
}
