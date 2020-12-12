
resource "local_file" "docker-env" {
    filename = "${path.module}/docker-env.sh"
    content = templatefile("./tmpl/docker-env-tmpl.sh", {
        vpc_arn: local.vpc_arn,
        vpc_id: local.vpc_id,
        ecs_arn: aws_ecs_cluster.main.arn,
        alb_arn: module.alb.this_lb_arn,
        rds_dbname: data.terraform_remote_state.db.outputs.tododb_name,
        rds_dbhost: data.terraform_remote_state.db.outputs.tododb-address,
        rds_user: data.terraform_remote_state.db.outputs.tododb_username,
        rds_passwd: data.terraform_remote_state.db.outputs.tododb_userpasswd
    })
}
