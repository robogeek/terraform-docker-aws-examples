
data "terraform_remote_state" "wordpress" {
  backend = "local"
  config = {
    path = "../wordpress-docker-ecs/terraform.tfstate"
  }
}

locals {
    efs_id = data.terraform_remote_state.wordpress.outputs.efs_id
}

resource "local_file" "deploy" {
    filename = "${path.module}/deploy.sh"
    content = templatefile("./tmpl/deploy-tmpl.sh", {
        efs_id: local.efs_id
    })
}
