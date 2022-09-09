AWS resources created

* VPC spanning 2 AZs with public subnets
* internet gateway
* single route table
* t3.micro ec2 instance with Nginx
* security group

![image](https://user-images.githubusercontent.com/1047259/189320223-7f2a35b5-5766-4332-8666-47cc0ee7ad7c.png)

```sh
terraform init

export TF_VAR_workstation_ip=$(curl -s ifconfig.me)

terraform apply -auto-approve
curl -I $(terraform output -raw web_instance_public_ip)

terraform workspace new dev || terraform workspace select dev 
terraform apply -auto-approve
curl -I $(terraform output -raw web_instance_public_ip)
terraform destroy

terraform workspace select default
terraform destroy
```

Taken from https://github.com/cloudacademy/terraform-aws/tree/main/exercises/exercise1.
