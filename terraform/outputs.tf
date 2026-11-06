output "public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web.public_ip
}

output "website_url" {
  description = "Open this in your browser after Ansible runs"
  value       = "http://${aws_instance.web.public_ip}"
}

output "ssh_command" {
  description = "Command to log in"
  value       = "ssh -i ~/.ssh/int333_key ubuntu@${aws_instance.web.public_ip}"
}
