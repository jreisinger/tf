* larger teams/projects tend to create errors and snow flakes when copy/pasting
* terragrunt DRY approach mitigates this problem

```sh
# create new identical environment
cp -r ./production ./development

# set new environment variables
perl -i -pe 's/Production/Development/g' ./development/environment_vars.yaml \
&& perl -i -pe 's+10.0.0.0/16+10.1.0.0/16+g' ./development/environment_vars.yaml \
&& perl -i -pe 's+10.0.0.0/24+10.1.0.0/24+g' ./development/environment_vars.yaml 

cd development

terragrunt init
terragrunt run-all apply
terragrunt run-all destroy

cd ..
rm -rf development
```

* manually delete S3 bucket (state file) and DynamoDB table (state file locking)