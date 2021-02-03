
resource "local_file" "deploy" {
    filename = "${path.module}/deploy.sh"
    content = templatefile("./tmpl/deploy-tmpl.sh", {
        # Only required if the corresponding values are
        # used in docker-compose.yml
        #
        # db_host: aws_db_instance.wordpress.address,
        # db_user: var.db_username,
        # db_password: var.db_passwd,
        # db_name: var.db_name,
        wp_id: aws_efs_file_system.wordpress.id,
        alb_arn: module.alb-dns.alb_arn,
        secret_db_access_arn: aws_secretsmanager_secret.wpdb-access.arn,
        overlay: local.overlay
    })
}

resource "local_file" "convert" {
    filename = "${path.module}/convert.sh"
    content = templatefile("./tmpl/convert-tmpl.sh", {
        wp_id: aws_efs_file_system.wordpress.id,
        alb_arn: module.alb-dns.alb_arn,
        secret_db_access_arn: aws_secretsmanager_secret.wpdb-access.arn,
        overlay: local.overlay
    })
}

resource "local_file" "docker-compose" {
    filename = "${path.module}/docker-compose.yml"
    content = templatefile("./tmpl/docker-compose.yml", {
        wp_id: aws_efs_file_system.wordpress.id,
        alb_arn: module.alb-dns.alb_arn,
        secret_db_access_arn: aws_secretsmanager_secret.wpdb-access.arn,
        overlay: local.overlay
    })
}

resource "local_file" "efs-mount" {
    filename = "${path.module}/efs-mount.sh"
    content = templatefile("./tmpl/efs-mount-tmpl.sh", {
        efs_id: aws_efs_file_system.wordpress.id,
        efs_nm: local.efs-ap-name
        // efs_dns: aws_efs_file_system.wordpress.dns_name
    })
}
