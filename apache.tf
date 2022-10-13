
resource "aws_security_group" "apache" {

  name        = "allow_admin"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "enduser from admin"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.bastion.id]
   
  }

  
  ingress {
    description      = "enduser from alb"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.alb.id]
   
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "stage-apache-sg"
  }
}

resource "aws_instance" "apache" {
  ami           = "ami-0f62d9254ca98e1aa"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  tags = {
    Name = "stage-bastion"
  }
}