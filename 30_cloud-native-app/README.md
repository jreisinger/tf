Cloud native application for voting about your favorite language.

Deploy AWS resources:

* 2 AZs with both public and private subnets
* IGW and NAT GW
* public and private route tables
* ALB load balancing traffic between ASG of Nginx web servers with FE and API
* MongoDB installed in private subnet
* SGs to secure traffic between components

NOTE: both FE and API will be deployed to same set of ASG instances to save costs
