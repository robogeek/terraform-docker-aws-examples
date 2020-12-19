
resource "local_file" "deploy" {
    filename = "${path.module}/../deploy.sh"
    content = templatefile("./tmpl/deploy-tmpl.sh", {
        db_host: aws_db_instance.wordpress.address,
        db_user: var.db_username,
        db_password: var.db_passwd,
        db_name: var.db_name
    })
}
