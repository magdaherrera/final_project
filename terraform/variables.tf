variable "environment" {
  type        = string
  description = "Environment for the deployment"
  default     = "dev"
}

variable "main_resources_name" {
  type        = string
  description = "Main resources across the deployment"
  default     = "flask-lambda"
}


variable "aws_resource_tags" {
  type        = map(string)
  description = "Tags to be applied to each resource this TF configuration creates."
  default = {
    project     = "project-alpha"
    version     = "1.2"
    environment = "prod"
    owner       = "dz@dzcol.com"
  }
}