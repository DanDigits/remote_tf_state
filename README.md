## Remote Terraform State Template
This repo is a template for creating remote S3 backends for terraform files

## Instructions
In variables.tfvars, change the name of bucket_name and table_name as desired, note however that "bucket_name", the name of your S3 bucket, has to be globally unique, so you might not get your choice of name. Once done, run
```
terraform apply -var-file="variables.tfvars"
```
and the S3 bucket will be created, and congrats, you now have a remote backend for terraform.

## Using the remote bucket
Fill in the respective information in the state.tfvars file, and uncomment the "backend" block on lines 11-13 (or in your future terraform installations, include it) and run
```
terraform init -reconfigure -backend-config="state.tfvars"
```
and you will have reconfigured the backend to the S3 bucket as listed in the state.tfvars file. 

Recognize also that the listings in the state.tfvars are the same as that which you'd put into the 'backend "s3"' block as well, they're just different ways of defining the remote terraform state.

## Destroying the remote bucket
```
terraform destroy -var-file="variables.tfvars"
```
Protection is in place for the actual bucket itself however (lines 23-25), just in case it has sensitive/important information. Destroy it accordingly.
