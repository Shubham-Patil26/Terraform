resource "aws_instance" "module_instance" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [ var.sgid ]
  
}