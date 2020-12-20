resource "aws_efs_file_system" "wordpress" {
  creation_token = "wordpress-files"

  tags = {
    Name = "wordpress-files"
  }
}
