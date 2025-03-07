TODO

* [x] create a temp Ubuntu cloud server (VM)
* [x] be able to ssh into the server
* [x] install nmap into the server
* [x] create var containing list of packages to install
* [x] cleanup

```sh
# just once after creating or pulling (maintains .terraform.lock.hcl)
terraform init

export AWS_ACCESS_KEY_ID="anaccesskey"
 export AWS_SECRET_ACCESS_KEY="asecretkey"
# or if you have profile in ~/.aws/credentials like
# [profile-name]
# aws_access_key_id = anaccesskey
# aws_secret_access_key = asecretkey
export AWS_PROFILE=<profile-name>

terraform plan
terraform apply [-var "region=us-east-1"]
terraform show
terraform state list
terraform output instance_public_ip
terraform destroy

ssh ubuntu@<instance_public_ip>
```