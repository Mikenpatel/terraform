variable "domain_name" {
  default = "www.mikenpatel.click"
  type=string
}

variable "hosted_zone_id"{
    default="Z02894083S0UP56WO6XYT"
    type=string
}

# variable "weight"{
#   default=50
# }

# variable "continent" {
#   type=string
#   default="SA"
# }

variable "identifier_for_route53_record"{
  type=string
}

variable "api-stage-name" {
  type=string
}




