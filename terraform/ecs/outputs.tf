
output "cluster_id"  { value = aws_ecs_cluster.main.id }
output "cluster_arn" { value = aws_ecs_cluster.main.arn }
// output "alb-dnsname" { value = aws_lb.todo.dns_name }
output "alb-dnsname" { value = module.alb.this_lb_dns_name }

output "todo-dns" { value = aws_route53_record.todo.*.fqdn    }

// output "service-discovery" { value = aws_service_discovery_service.redis-service }
// output "sd-zone" { value = aws_service_discovery_private_dns_namespace.example }
