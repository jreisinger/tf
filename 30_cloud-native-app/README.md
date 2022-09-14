Cloud native application for voting about your favorite language. This folder shows how to modularize a complex deployment. Network module uses vpc module library.

Deploy AWS resources:

* 2 AZs with both public and private subnets
* IGW and NAT GW
* public and private route tables
* ALB load balancing traffic between ASG of Nginx web servers with FE and API
* MongoDB installed in private subnet
* SGs to secure traffic between components
* bastion jump host

NOTE: both FE and API will be deployed to same set of ASG instances to save costs

![image](https://user-images.githubusercontent.com/1047259/189708296-57c0873c-f1de-4155-9dd0-53032fc179f1.png)

Taken from https://github.com/cloudacademy/terraform-aws/tree/main/exercises/exercise4. With the following modifications:

- I changed the region and AZs
- I commented out `key_name` from everywhere (I can't ssh to VMs but that's ok) 
- I changed the version of `hashicorp/aws` provider
- I replaced hashicorp/template provider with hashicorp/cloudinit provider 