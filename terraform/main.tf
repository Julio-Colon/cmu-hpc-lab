resource "aws_security_group" "hpc_sg" {
  name        = "hpc-cluster-sg"
  description = "Allows SSH and internal cluster traffic"

  # Allow SSH the current IP address
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.body)}/32"]
  }

  # Allow all traffic between instances in this sg
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  
  # Allows all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Get IP where IaC code is being run
data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_instance" "controller" {
  ami           = "ami-0ecb62995f68bb549" # Ubuntu 24.04 LTS
  instance_type = "t2.micro"
  key_name      = var.key_name
  security_groups = [aws_security_group.hpc_sg.name]

  tags = {
    Name = "controller"
    Role = "hpc-controller"
  }
}

resource "aws_instance" "compute" {
  count         = 2 # Number of compute nodes
  ami           = "ami-0ecb62995f68bb549" # Ubuntu 24.04 LTS
  instance_type = "t2.micro"
  key_name      = var.key_name
  security_groups = [aws_security_group.hpc_sg.name]

  tags = {
    Name = "compute-0${count.index + 1}"
    Role = "hpc-compute"
  }
}
