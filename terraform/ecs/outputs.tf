
output "cluster_id"  { value = aws_ecs_cluster.main.id }
output "cluster_arn" { value = aws_ecs_cluster.main.arn }
// output "alb-dnsname" { value = aws_lb.todo.dns_name }
output "alb-dnsname" { value = module.alb.this_lb_dns_name }
