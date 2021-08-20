provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

  default_tags {
    tags = {
      Name        = "tf-test-automation"
      Product     = "test-automation"
      Environment = "test"
    }
  }
}

## ami

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

## vpc

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

## subnet

resource "aws_subnet" "sn" {
  vpc_id     = aws_default_vpc.default.id
  cidr_block = var.subnet_cidr_block
  tags = {
    Name = "${var.namespace}-sn"
  }
}

## security

locals {
  ingress_rules = var.ingress_with_cidr_blocks
  egress_rules  = var.egress_with_cidr_blocks
}

resource "aws_security_group" "allow_tls" {
  name        = "${var.namespace}-sg"
  description = "Allow TLS inbound and outbound traffic"
  vpc_id      = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = [ingress.value.cidr_blocks]
    }
  }

  dynamic "egress" {
    for_each = local.egress_rules

    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = [egress.value.cidr_blocks]
    }
  }

  tags = {
    Name = "${var.namespace}-allow_tls"
  }
}

## ec2

resource "aws_instance" "kafka_cli" {
  ami                         = var.ami
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.sn.id
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = var.private_key
  }

  # install kafka
  #   provisioner "file" {
  #     content     = templatefile("${path.module}/scripts/init.sh", { zk_ip = var.zk_ip, kafka_topic = var.kafka_topic })
  #     destination = "/tmp/init.sh"
  #   }

  # create a topic
  provisioner "remote-exec" {
    inline = [
        "/home/ubuntu/kafka/bin/kafka-topics.sh --zookeeper ${var.zk_ip} --replication-factor 3 --partitions 6 --topic ${var.kafka_topic} --create"
    ]
  }

  tags = {
    Name = "${var.namespace}-kafka_cli"
  }
}