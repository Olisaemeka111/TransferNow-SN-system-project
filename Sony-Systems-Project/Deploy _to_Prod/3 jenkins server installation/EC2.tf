


# create default vpc if one does not exit
resource "aws_default_vpc" "default_vpc" {

  tags = {
    Name = "default vpc"
  }
}


# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}


# create default subnet-1 if one does not exit
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags = {
    Name = "default subnet 1"
  }
}

# create default subnet-2 if one does not exit
resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available_zones.names[1]

  tags = {
    Name = "default subnet 2"
  }
}

# create default subnet-3 if one does not exit
resource "aws_default_subnet" "default_az3" {
  availability_zone = data.aws_availability_zones.available_zones.names[2]

  tags = {
    Name = "default subnet 3"
  }
}


# create security group for the ec2 instance
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2 security group"
  description = "allow access on ports 8080 and 22"
  vpc_id      = aws_default_vpc.default_vpc.id

  # allow access on port 8080
  ingress {
    description = "http proxy access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # allow access on port 22
  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Corrected CIDR block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins server security group"
  }
}


# use data source to get a registered amazon linux 2 ami
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


# Launch the first EC2 instance and install website
resource "aws_instance" "ec2_instance_1" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.medium"
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name               = "web"
  # user_data            = file("install_jenkins.sh")

  tags = {
    Name = "Jenkins server 1@ Prod"
  }
}


# Launch the first EC2 instance and install website
resource "aws_instance" "ec2_instance_2" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.medium"
  subnet_id              = aws_default_subnet.default_az2.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name               = "web"
  # user_data            = file("install_jenkins.sh")

  tags = {
    Name = "Jenkins server 2@ Dev"
  }
}

# Launch the first EC2 instance and install website
resource "aws_instance" "ec2_instance_3" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.medium"
  subnet_id              = aws_default_subnet.default_az3.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name               = "web"
  # user_data            = file("install_jenkins.sh")

  tags = {
    Name = "Jenkins server 3@ UAT"
  }
}


# an empty resource block
resource "null_resource" "name_1" {

  # ssh into the first ec2 instance 
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/Downloads/web (1).pem")
    host        = aws_instance.ec2_instance_1.public_ip
  }

  # copy the install_jenkins.sh file from your computer to the ec2 instance 
  provisioner "file" {
    source      = "install_jenkins.sh"
    destination = "/tmp/install_jenkins.sh"
  }

  # set permissions and run the install_jenkins.sh file
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install_jenkins.sh",
      "sh /tmp/install_jenkins.sh",
    ]
  }

  # wait for ec2 instance 1 to be created
  depends_on = [aws_instance.ec2_instance_1]
}


# an empty resource block
resource "null_resource" "name_2" {

  # ssh into the second ec2 instance 
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/Downloads/web (1).pem")
    host        = aws_instance.ec2_instance_2.public_ip
  }

  # copy the install_jenkins.sh file from your computer to the ec2 instance 
  provisioner "file" {
    source      = "install_jenkins.sh"
    destination = "/tmp/install_jenkins.sh"
  }

  # set permissions and run the install_jenkins.sh file
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install_jenkins.sh",
      "sh /tmp/install_jenkins.sh",
    ]
  }

  # wait for ec2 instance 1 to be created
  depends_on = [aws_instance.ec2_instance_2]
}


# an empty resource block
resource "null_resource" "name_3" {

  # ssh into the third ec2 instance 
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/Downloads/web (1).pem")
    host        = aws_instance.ec2_instance_3.public_ip
  }

  # copy the install_jenkins.sh file from your computer to the ec2 instance 
  provisioner "file" {
    source      = "install_jenkins.sh"
    destination = "/tmp/install_jenkins.sh"
  }

  # set permissions and run the install_jenkins.sh file
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install_jenkins.sh",
      "sh /tmp/install_jenkins.sh",
    ]
  }

  # wait for ec2 instance 1 to be created
  depends_on = [aws_instance.ec2_instance_3]
}



# print the url of the jenkins server 1
output "website_url_1" {
  value = join("", ["http://", aws_instance.ec2_instance_1.public_dns, ":", "8080"])
}

# print the url of the jenkins server 2
output "website_url_2" {
  value = join("", ["http://", aws_instance.ec2_instance_2.public_dns, ":", "8080"])
}

# print the url of the jenkins server 3
output "website_url_3" {
  value = join("", ["http://", aws_instance.ec2_instance_3.public_dns, ":", "8080"])
}

