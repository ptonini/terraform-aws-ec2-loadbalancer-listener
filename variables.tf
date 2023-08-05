variable "load_balancer" {
  type = object({
    arn = string
  })
}

variable "port" {
  type     = number
  default  = "80"
  nullable = false
}

variable "protocol" {
  type     = string
  default  = "HTTP"
  nullable = false

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
  type    = list(string)
  default = []
}

variable "rules" {
  default = {}
}