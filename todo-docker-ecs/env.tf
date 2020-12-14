
resource "local_file" "deploy" {
    filename = "${path.module}/deploy.sh"
    content = templatefile("./tmpl/deploy-tmpl.sh", {
        // vpc_arn: local.vpc_arn,
        // vpc_id: local.vpc_id,
        // ecs_arn: aws_ecs_cluster.main.arn,
        // alb_arn: module.alb.this_lb_arn,
        rds_dbname: data.terraform_remote_state.db.outputs.tododb_name,
        rds_dbhost: data.terraform_remote_state.db.outputs.tododb-address,
        rds_user: data.terraform_remote_state.db.outputs.tododb_username,
        rds_passwd: data.terraform_remote_state.db.outputs.tododb_userpasswd,
        project_name: local.project-name
    })
}

resource "local_file" "stop" {
    filename = "${path.module}/stop.sh"
    content = templatefile("./tmpl/stop-tmpl.sh", {
        project_name: local.project-name
    })
}

resource "local_file" "status" {
    filename = "${path.module}/status.sh"
    content = templatefile("./tmpl/status-tmpl.sh", {
        project_name: local.project-name
    })
}

resource "local_file" "logs" {
    filename = "${path.module}/logs.sh"
    content = templatefile("./tmpl/logs-tmpl.sh", {
        project_name: local.project-name
    })
}

locals {
    project-name = "${lower(local.env_name)}-todo"
}
