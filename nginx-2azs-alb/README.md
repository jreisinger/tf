AWS resources created

* VPC spanning 2 AZs with public and private subnets
* internet gateway and NAT gateway
* public and private route tables
* application load balancer balancing traffic across an auto scaling group of Nginx web servers
* security groups to secure network traffic between various components

![image](https://user-images.githubusercontent.com/1047259/189343248-1e87f4b8-33f9-4108-8316-f8d06c8fd87d.png)

```sh
terraform init

terraform apply -auto-approve
terraform destroy
```

Taken from https://github.com/cloudacademy/terraform-aws/tree/main/exercises/exercise2.
