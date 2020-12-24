resource "aws_efs_file_system" "wordpress" {
  creation_token = "wordpress-files"
  encrypted = true

  tags = {
    Name = "wordpress-files"
  }
}
