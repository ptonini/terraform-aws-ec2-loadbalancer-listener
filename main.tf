locals {
  builtin_actions = {
    redirect_to_https = {
      type = "redirect"
      options = {
        port     = "443"
        protocol = "HTTPS"
      }
    }
  }
  selected_builtin_actions_count = length(var.builtin_actions)
  selected_builtin_actions       = { for l in var.builtin_actions : (1 + index(var.builtin_actions, l)) => local.builtin_actions[l] }
  extra_actions                  = { for k, v in var.actions : (k + local.selected_builtin_actions_count) => v }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = var.load_balancer.arn
  port              = var.port
  protocol          = var.protocol
  certificate_arn   = var.certificate == null ? null : var.certificate.arn
  dynamic "default_action" {
    for_each = merge(local.selected_builtin_actions, local.extra_actions)
    content {
      order            = default_action.key
      type             = default_action.value["type"]
      target_group_arn = default_action.value["type"] == "forward" ? default_action.value["target_group_arn"] : null
      dynamic "redirect" {
        for_each = default_action.value["type"] == "redirect" ? { 0 = default_action.value["options"] } : {}
        content {
          host        = try(redirect.value["host"], null)
          path        = try(redirect.value["path"], null)
          port        = try(redirect.value["port"], null)
          protocol    = try(redirect.value["protocol"], null)
          query       = try(redirect.value["query"], null)
          status_code = try(redirect.value["status_code"], "HTTP_301")
        }
      }
    }
  }
}

resource "aws_lb_listener_rule" "this" {
  for_each     = var.rules
  priority     = each.key
  listener_arn = aws_alb_listener.this.arn
  action {
    type = each.value["type"]
    dynamic "redirect" {
      for_each = each.value["type"] == "redirect" ? { 0 = each.value["options"] } : {}
      content {
        host        = try(redirect.value["host"], null)
        path        = try(redirect.value["path"], null)
        port        = try(redirect.value["port"], null)
        protocol    = try(redirect.value["protocol"], null)
        query       = try(redirect.value["query"], null)
        status_code = try(redirect.value["status_code"], "HTTP_301")
      }
    }
  }
  dynamic "condition" {
    for_each = each.value["conditions"]
    content {
      dynamic "host_header" {
        for_each = try(condition.value["host_header"]) != null ? { 0 = condition.value["host_header"] } : {}
        content {
          values = condition.value["host_header"]
        }
      }
    }
  }
}
