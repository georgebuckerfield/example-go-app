variable "environment" {
  type = string
  default = "dev"
}
variable "region" {
  type = string
  default = "eu-west-2"
}
variable "app_dns_name" {
  type = string
}
variable "app_service_name" {
  type = string
  default = "goapp"
}
variable "app_docker_image" {
  type = string
}
variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}
variable "vpc_public_subnet_ranges" {
  type = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}
variable "vpc_private_subnet_ranges" {
  type = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}
variable "vpc_availability_zones" {
  type = list(string)
  default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}
variable "alb_acm_cert_id" {
  type = string
}
variable "cdn_acm_cert_id" {
  type = string
}
variable "ecs_cluster_name" {
  type = string
  default = "dev-cluster"
}
variable "ecs_service_task_count" {
  type = number
  default = 2
}
variable "ecs_service_port_number" {
  type = number
  default = 5000
}
variable "ecs_task_log_group" {
  type = string
  default = "/aws/fargate/example"
}
variable "alb_logging_accounts" {
  type    = map
  default = {
    "eu-west-1" = "156460612806"
    "eu-west-2" = "652711504416"
    "eu-west-3" = "009996457667"
  }
}
