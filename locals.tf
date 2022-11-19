locals {
  builtin_actions = {
    redirect_to_https = {
      type = "redirect"
      options = {
        port = "443"
        protocol = "HTTPS"
      }
    }
  }
  selected_builtin_actions_count = length(var.builtin_actions)
  selected_builtin_actions = {for l in var.builtin_actions : (1 + index(var.builtin_actions, l)) => local.builtin_actions[l]}
  extra_actions = {for k, v in var.actions : (k + local.selected_builtin_actions_count) => v}
  actions = merge(local.selected_builtin_actions, local.extra_actions)
}