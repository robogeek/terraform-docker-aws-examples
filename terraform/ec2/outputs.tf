output "ec2-srv1-arn" { value = aws_instance.srv1.arn }
output "ec2-srv1-dns" { value = aws_instance.srv1.public_dns }
output "ec2-srv1-ip"  { value = aws_instance.srv1.public_ip }

output "ec2-srv2-arn" { value = aws_instance.srv2.arn }
output "ec2-srv2-dns" { value = aws_instance.srv2.public_dns }
output "ec2-srv2-ip"  { value = aws_instance.srv2.public_ip }
