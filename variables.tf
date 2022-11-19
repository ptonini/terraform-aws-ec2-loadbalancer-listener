variable "load_balancer" {
  type = object({
    arn = string
  })
}

variable "port" {
  type = number
  default = "80"
}

variable "protocol" {
  type = string
  default = "HTTP"
}

variable "certificate" {
  type = object({
    arn = string
  })
  default = {
    arn = null
  }
}

variable "actions" {
  default = {}
}

variable "builtin_actions" {
  type = list(string)
  default = []
}

variable "rules" {
  default = {}
}