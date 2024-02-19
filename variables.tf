variable "key_pair" {
  description = "Name of key-pair used to SSH to instances"
  type        = string
}

variable "gitlab_token" {
  description = "Gitlab CICD token"
  type        = string
}
