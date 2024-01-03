variable "load_balancer" {
  type = object({
    arn = string
  })
}

variable "port" {
  type    = number
  default = "80"
  nullable = false
}

variable "protocol" {
  type    = string
  default = "HTTP"
  nullable = false
}

variable "certificate" {
  type = object({
    arn = optional(string)
  })
  default = {}
  nullable = false
}

variable "actions" {
  type = map(object({
    type             = string
    target_group_arn = optional(string)
    redirect_options = optional(object({
      host        = optional(string)
      path        = optional(string)
      port        = optional(string)
      protocol    = optional(string)
      query       = optional(string)
      status_code = optional(string, "HTTP_301")
    }))
  }))
  default = {}
  nullable = false
}

variable "rules" {
  type = map(object({
    type = string
    redirect_options = optional(object({
      host        = optional(string)
      path        = optional(string)
      port        = optional(string)
      protocol    = optional(string)
      query       = optional(string)
      status_code = optional(string, "HTTP_301")
    }))
    conditions = map(object({
      host_header = optional(string)
    }))
  }))
  default = {}
  nullable = false
}