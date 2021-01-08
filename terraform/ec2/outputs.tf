
output "srv-dns"       { value = aws_instance.srv.*.public_dns }
output "srv-addresses" { value = aws_instance.srv.*.public_ip }
output "srv-hostnm"    { value = var.instances.*.host_name }
output "srv-ssh"       { value = var.instances.*.ssh_connect }
