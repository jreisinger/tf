* terragrunt is an open-source tool that acts as a thin wrapper around terraform
* it enables configurations to be more DRY
* it allows state configuration to be defined once and re-used in multiple projects/environments 

```sh
terragrunt init
terragrunt run-all apply
terragrunt run-all destroy
```

* manually delete S3 bucket (state file) and DynamoDB table (state file locking)