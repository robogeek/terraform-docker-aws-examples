
resource "local_file" "deploy" {
    filename = "${path.module}/../deploy.sh"
    content = templatefile("./tmpl/deploy-tmpl.sh", {
        db_host: aws_db_instance.wordpress.address,
        db_user: var.db_username,
        db_password: var.db_passwd,
        db_name: var.db_name,
        wp_id: aws_efs_file_system.wordpress.id,
        alb_arn: module.alb.this_lb_arn,
        alb_name: local.alb_name
    })
}