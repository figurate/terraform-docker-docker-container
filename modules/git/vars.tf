variable "name" {
  description = "Docker container name"
  default     = "git"
}

variable "command" {
  description = "Git command to execute"
  default     = "fetch"
}

variable "rm" {
  description = "Automatically remove container after execution"
  default     = true
}

variable "home_dir" {
  description = "A path mounted as the (writable) home directory in the gradle container"
  default     = "~"
}

variable "host_path" {
  description = "A path containing the project gradle input files (defaults to module root)"
  default     = null
}
