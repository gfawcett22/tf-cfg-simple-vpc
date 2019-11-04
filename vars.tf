variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The region to deploy resources"
}

variable "profile" {
  type        = string
  default     = "default"
  description = "The aws profile to use"
}

variable "vpc_name" {
  type        = string
  default     = "test-vpc"
  description = "The name of the vpc"
}

variable "cidr" {
  type        = string
  default     = "10.0.0.0/18"
  description = "The CIDR Block for the VPC. This should be a /18"
}

variable "az_count" {
  type        = number
  default     = 2
  description = "The number of availability zones to use. The region must have at least this many AZs available. Up to 4 AZs may be used."
}

variable "production" {
  type        = bool
  default     = false
  description = "Describes if the desired output should be a production environment."
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = false
  description = "Should be true to enable DNS hostnames in the VPC"
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Should be true to enable DNS support in the VPC"
}

variable "vpc_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for the VPC"
}

variable "private_subnet_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for private subnets"
}

variable "public_subnet_tags" {
  type        = map(string)
  default     = { "kubernetes.io/role/elb" = "1" }
  description = "Additional tags for public subnets"
}

variable "cluster_name" {
  type        = string
  default     = "simple-cluster"
  description = "Name for the cluster"
}