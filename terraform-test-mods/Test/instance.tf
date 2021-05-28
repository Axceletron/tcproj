provider "aws" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.*"]
  }

  owners = ["661984667850","amazon"]
}
output "ami" {

  value = data.aws_ami.ubuntu.id 
}
/*
resource "aws_instance" "foo" {
  ami           = data.aws_ami.ubuntu.id 
  instance_type = "t2.micro"
  key_name = "test-keypair"
  ebs_block_device {
      device_name = "/dev/sda1"
      volume_size = 10
  }
  /*provisioner "remote-exec" {
    inline = [
      "sudo yum update",
      "sudo amazon-linux-extras install nginx1",
      "service nginx start"
    ]
  }/
}
*/
/*resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 40

  tags = {
    Name = "HelloWorld"
  }
}*/
