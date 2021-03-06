output "output_dir" {
  description = "The host output directory for any generated artefacts"
  value       = "${var.host_path}/build"
}

output "exit_code" {
  description = "Exit code of container"
  value       = module.container.exit_code
}

output "container_logs" {
  description = "Logs from container execution"
  value       = module.container.container_logs
}
