TODO

* [x] create a temp cloud server
* [x] create a DNS RR for the server
* [x] be able to ssh into the server
* [x] install nmap into the server
* [x] create var containing list of packages to install
* [x] cleanup

```sh
# just once after creating or pulling (maintains .terraform.lock.hcl)
terraform init

terraform plan
terraform apply [-var "instance_name=YetAnotherName"]
terraform show
terraform state list
terraform output instance_public_name
terraform destroy
```