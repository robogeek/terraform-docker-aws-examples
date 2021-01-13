
output "lb-ips" { value = aws_route53_record.lb_dns.*.records }
output "lb-dns" { value = aws_route53_record.lb_dns.*.fqdn    }

output "servers-ips" { value = aws_route53_record.srv.*.records   }
output "servers-dns" { value = aws_route53_record.srv.*.fqdn      }

