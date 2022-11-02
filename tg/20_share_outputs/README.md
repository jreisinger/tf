* in larger projects you should split infra components that change rarely (vpc, network) from those that change more often (ec2)
* use `dependency` blocks to order components and pass data between them
* use `generate` block to generate files on the fly

```sh
terragrunt init
terragrunt run-all apply
terragrunt run-all destroy
```

* manually delete S3 bucket (state file) and DynamoDB table (state file locking)