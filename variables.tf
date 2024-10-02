variable "db_name" {
  description = "Database Name"
}

variable "db_username" {
  description = "Database username"
}

variable "db_password" {
  description = "Database password"
  sensitive   = true
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}
