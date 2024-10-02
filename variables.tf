variable "db_name" {
  description = "Database Name"
  default     = "snack-api-db"
}

variable "db_username" {
  description = "Database username"
  default     = "root"
}

variable "db_password" {
  description = "Database password"
  default     = "root"
  sensitive   = true
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}
