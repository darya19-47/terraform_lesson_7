variable "do_token" {
type = string
description = "Access token to digital ocean"
}

variable "my_ssh_key_name" {
  type = string
  description = "Public SSh key name"
}

variable "my_ssh_key_path" {
  type = string
  description = "Path to ssh key location"
}

variable "rebrain_ssh_key" {
  type = string
  description = "Rebrain public ssh key"
}
variable "parametrs" {
  type = object(
    {
      cpu_size = number
      ram_size = number
      disk_size = number
      image_type = string
      image_name = string
    }
  )
}

variable "devops_tag" {
 type = string
 descrdescription = "devops tag for each resources that can be mark" 
}

variable "email_tag" {
  type = string
  description = "user email for each resources that can be mark"
}

variable "aws_access_key" {
  type = string
  description = "aws accsess key"
}

variable "aws_secret_key" {
  type = string
  description = "aws secret key"
}

variable "aws_region" {
  type = "string"
  description = "region used for creation aws"
}

variable "aws_zone" {
  type = "string"
  description = "Zone where DNS will be created"
}

variable "vps_count" {
  type = number
  description = "Number of created VPS"
}

variable "default_password" {
  type = string
  default = "Password123"
}