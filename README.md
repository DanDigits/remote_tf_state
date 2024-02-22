## Terraform State Template
This repo is a template for creating remote backends for terraform files

## Instructions
In variables.tfvars, change the name of bucket_name and table_name as desired, note however that "bucket_name", the name of your S3 bucket, has to be globally unique, so you might not get your choice of name. Once done, run
```
terraform apply -var-file="variables.tfvars"
```
and the S3 bucket will be created. 

## Using the remote bucket
Uncomment the "backend" block on lines 11-13 (or in your future terraform installations; make sure its 'backend "s3"' for S3 remote backends) and run
```
terraform init -reconfigure -backend-config="state.tfvars"
```
and you will have reconfigured the backend to the S3 bucket as listed in the state.tfvars file. Recognize also that the listing in the state.tfvars is the same as that which you'd put into the 'backend "s3"' block as well, they're just different ways of defining the remote terraform state.

## Destroying the remote bucket
```
terraform destroy -var-file="variables.tfvars"
```