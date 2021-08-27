## Install
### Terraform

[install doc](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### AWS Cli

[install doc](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

## Config
```bash
$ aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-west-2
```


## Emqx
### Apply
```bash
cd services/kafka-cli
terraform init
terraform apply -auto-approve -var="zk_ip=ip:2181" -var="kafka_topic=topic name"
```

### Destory
```bash
cd emqx
terraform init
terraform destroy -auto-approve -var="zk_ip=ip:2181" -var="kafka_topic=topic name"
```