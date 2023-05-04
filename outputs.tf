output "random_password" {
  value = random_password.password
  description = "Random password for VPS user"
  sensitive = true
}