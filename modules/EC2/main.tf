resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = var.security_group_ids
  subnet_id     = var.subnet_id
  user_data     = var.user_data

  tags = {
    Name = var.instance_name
  }
}
