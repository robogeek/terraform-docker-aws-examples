
output "srv-dns"       { value = aws_instance.srv.*.public_dns }
output "srv-addresses" { value = aws_instance.srv.*.public_ip }
output "srv-ssh"       { value = var.configuration[local.env_name].*.ssh_connect }