
output "db_name"     { value = var.db_name }
output "db_username" { value = var.db_username }
output "db_passwd"   { value = var.db_passwd }

output "wpdb-address" { value = aws_db_instance.wordpress.address }

output "wp_id"       { value = aws_efs_file_system.wordpress.id }
output "wp_arn"      { value = aws_efs_file_system.wordpress.arn }

output "default_vpc_id"  { value = local.default-vpc-id }
output "default_vpc_subnets" { value = local.default-vpc-subnets }
// output "default_vpc" { value = data.aws_vpcs.default-vpc }
output "default_vpc_cidrs" { value = local.default-vpc-cidrs }

output "alb_dns"      { value = module.alb.this_lb_dns_name }
output "alb_arn"      { value = module.alb.this_lb_arn }
output "alb_id"       { value = module.alb.this_lb_id }
