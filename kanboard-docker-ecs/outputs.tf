

output "db-address"  { value = aws_db_instance.kanboard.address }
output "db-endpoint" { value = aws_db_instance.kanboard.endpoint }
output "db-identifier" { value = aws_db_instance.kanboard.identifier }
output "db-name"     { value = aws_db_instance.kanboard.name }
output "db-id"       { value = aws_db_instance.kanboard.id }
output "db-arn"      { value = aws_db_instance.kanboard.arn }

output "db_name"     { value = var.db_name }
output "db_username" { value = var.db_username }
output "db_passwd"   { value = var.db_passwd }

// output "aws_profile" {  value = var.aws_profile }
// output "aws_region"  {  value = var.aws_region }

// output "project_name" { value = var.project_name }

// output "env_name" { value = var.env_name }

// output "vpc_id"   { value = module.vpc-example.vpc_id }
// output "vpc_arn"  { value = module.vpc-example.vpc_arn }
// output "vpc_cidr" { value = module.vpc-example.vpc_cidr_block }

// output "sg_id"    { value = aws_security_group.lb.id }

// output "igw_id"   { value = module.vpc-example.igw_id }
// output "igw_arn"  { value = module.vpc-example.igw_arn }

// output "azs"      { value = module.vpc-example.azs }

// output "lb_name"  { value = local.lb_name }

// output "ecs-name" { value = aws_ecs_cluster.main.name }
// output "ecs-id"   { value = aws_ecs_cluster.main.id }
// output "ecs-arn"  { value = aws_ecs_cluster.main.arn }
