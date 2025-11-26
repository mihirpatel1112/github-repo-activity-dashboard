terraform{
	required_providers{
		aws = {
			source = "hashicorp/aws"
			version = "~>5.0"
		}
	}
	required_version = ">=1.2.0"
}

provider "aws" {
	region = "ap-southeast-2"
	profile = "mihir.patel"
}

data "aws_vpc" "default" {
	default = true
}

resource "aws_security_group" "newsg_1" {
	name = "newsg_1"
	vpc_id = data.aws_vpc.default.id
	tags = {
		Name = "newsg_1"
	}
}

resource "aws_vpc_security_group_ingress_rule" "igrule_1"{
	security_group_id = aws_security_group.newsg_1.id
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_vpc_security_group_ingress_rule" "igrule_2"{
	security_group_id = aws_security_group.newsg_1.id
	from_port = 80
	to_port = 80
	ip_protocol = "http"
	cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "igrule_3"{
	security_group_id = aws_security_group.newsg_1.id
	from_port = 443
	to_port = 443
	ip_protocol = "https"
	cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "egrule_1" {
	security_group_id = aws_security_group.newsg_1.id
	ip_protocol = "-1"
	cidr_ipv4 = "0.0.0.0/0"
}

variable "public_key" {
	type = string
	default = "~/.ssh/id_rsa.pub"
}

resource "aws_key_pair" "ssh_key" {
	key_name = "ec2_key"
	public_key = file(var.public_key)
}
