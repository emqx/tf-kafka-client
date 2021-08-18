variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "namespace" {
  description = "kafka client namespace"
  type        = string
  default     = "tf-kafka-cli"
}

variable "access_key" {
  description = "AWS access key"
  type        = string
  default     = null
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
  default     = null
}

variable "ingress_with_cidr_blocks" {
  description = "ingress of kafka with cidr blocks"
  type        = list(any)
  default = [
    {
      description = "port of ssh"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "port of kafka"
      from_port   = 9094
      to_port     = 9094
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "port of zookeeper"
      from_port   = 2181
      to_port     = 2181
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

variable "egress_with_cidr_blocks" {
  description = "egress with cidr blocks"
  type        = list(any)
  default = [
    {
      description = "all"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

variable "key_name" {
  description = "the name of key"
  type        = string
  default     = "aws-sg-bench"
}

variable "subnet_cidr_block" {
  description = "subnets of vpc"
  type        = string
  default     = "172.31.201.0/24"
}

## kafka

variable kafka_ip {
  type        = string
  default     = null
  description = "a ip of kafka cluster"
}

variable kafka_topic {
  type        = string
  default     = "testTopic"
  description = "the topic of kafka"
}