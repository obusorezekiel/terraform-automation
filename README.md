# AUTOMATE INFRASTRUCTURE WITH IAC USING TERRAFORM. PART 2

### Create 4 private subnets keeping in mind following principles:
- Make sure you use variables or length() function to determine the number of AZs
- Use variables and cidrsubnet() function to allocate vpc_cidr for subnets
- Keep variables and resources in separate files for better code structure and readability
- Tags all the resources you have created so far. Explore how to use format() and count functions to automatically tag subnets with its respective number.
  
![Screenshot from 2022-11-18 12-24-28](https://user-images.githubusercontent.com/23356682/202694770-dd7f84f9-ea69-4689-8ae6-8a0853776fb3.png)

### Internet Gateways & format() function
Create an Internet Gateway in a separate Terraform file `internet_gateway.tf`. This serves as an entry point for internet into the virtual private network

![Screenshot from 2022-11-18 12-30-10](https://user-images.githubusercontent.com/23356682/202695622-a02fb742-6cb9-47fc-9fd3-7f3f12dce621.png)

###NAT Gateways
- Create 1 NAT Gateways and 1 Elastic IP (EIP) addresses

- Now use similar approach to create the NAT Gateways in a new file called `natgateway.tf`.

Note: We need to create an Elastic IP for the NAT Gateway, and you can see the use of depends_on to indicate that the Internet Gateway resource must be available before this should be created. Although Terraform does a good job to manage dependencies, but in some cases, it is good to be explicit.

![Screenshot from 2022-11-18 12-35-39](https://user-images.githubusercontent.com/23356682/202699289-1ba9b8c3-9be4-4f68-9ae7-63e4ba2ff445.png)

### AWS ROUTES
- Create a file called route_tables.tf and use it to create routes for both public and private subnets, create the below resources. Ensure they are properly tagged.

- aws_route_table
- aws_route
- aws_route_table_association

![Screenshot from 2022-11-18 12-53-09](https://user-images.githubusercontent.com/23356682/202699433-f27c50f0-30c1-411b-8ed6-d645bc5698cf.png)


### AWS Identity and Access Management
### IaM and Roles
We want to pass an IAM role our EC2 instances to give them access to some specific resources, so we need to do the following:

Create AssumeRole
Assume Role uses Security Token Service (STS) API that returns a set of temporary security credentials that you can use to access AWS resources that you might not normally have access to. These temporary credentials consist of an access key ID, a secret access key, and a security token. Typically, you use AssumeRole within your account or for cross-account access.

Add the following code to a new file named `roles.tf`

![Screenshot from 2022-11-18 12-29-49](https://user-images.githubusercontent.com/23356682/202700067-dfa08281-a901-449f-8558-684cb7fa4b8d.png)

#
###  Further Resources to be created
#
As per our architecture we need to do the following:

- Create Security Groups
- Create Target Group for Nginx, WordPress and Tooling
- Create certificate from AWS certificate manager
- Create an External Application Load Balancer and Internal Application Load Balancer.
- Create launch template for Bastion, Tooling, Nginx and WordPress
- Create an Auto Scaling Group (ASG) for Bastion, Tooling, Nginx and WordPress
- Create Elastic Filesystem
- Create Relational Database (RDS)


### CREATE SECURITY GROUPS
We are going to create all the security groups in a single file, then we are going to refrence this security group within each resources that needs it.

Create a file and name it `security.tf`, copy and paste the code below


![Screenshot from 2022-11-18 12-58-55](https://user-images.githubusercontent.com/23356682/202700355-89d1da6c-a49d-4f93-af99-84b52f0b9dd9.png)


### CREATE CERTIFICATE FROM AMAZON CERIFICATE MANAGER
Create `cert.tf file` and add the following code snippets to it.

![Screenshot from 2022-11-18 12-59-20](https://user-images.githubusercontent.com/23356682/202700405-98421276-246d-4c01-86fc-b2c6a4117c61.png)

### Create an external (Internet facing) Application Load Balancer (ALB)
Create a file called alb.tf

![Screenshot from 2022-11-18 13-00-37](https://user-images.githubusercontent.com/23356682/202700635-0d8ec822-4471-4bdb-ae66-736ff849a59c.png)


First of all we will create the ALB, then we create the target group and lastly we will create the lsitener rule.

ALB
ALB-target
ALB-listener
We need to create an ALB to balance the traffic between the Instances:

To inform our ALB to where route the traffic we need to create a Target Group to point to its targets

Then we will need to create a Listner for this target Group

Repeat same for Internal Facing Loadbalancer

### CREATING AUSTOALING GROUPS
This Section we will create the Auto Scaling Group (ASG)
Now we need to configure our ASG to be able to scale the EC2s out and in depending on the application traffic.

Before we start configuring an ASG, we need to create the launch template and the the AMI needed. For now we are going to use a random AMI from AWS, we will use Packerto create our ami later on.

Based on our Architetcture we need for Auto Scaling Groups for bastion, nginx, wordpress and tooling, so we will create two files; asg-bastion-nginx.tf will contain Launch Template and Austoscaling group for Bastion and Nginx, then asg-wordpress-tooling.tf will contain Launch Template and Austoscaling group for wordpress and tooling.

Useful Terraform Documentation, go through this documentation and understand the arguement needed for each resources:

SNS-topic
SNS-notification
Autoscaling
Launch-template

Create asg-bastion-nginx.tf and paste all the code snippet below;

![Screenshot from 2022-11-18 13-02-01](https://user-images.githubusercontent.com/23356682/202700887-bc557a0b-45c4-4969-a0ff-ab7bb930c316.png)

Create asg-wordpress-tooling.tf and paste all the code snippet below;

![Screenshot from 2022-11-18 13-05-45](https://user-images.githubusercontent.com/23356682/202701467-c9466aad-894c-4d46-ac56-8ec92c0d9c28.png)


### STORAGE AND DATABASE
Useful Terraform Documentation, go through this documentation and understand the arguement needed for each resources:

RDS
EFS
KMS
Create Elastic File System (EFS)
In order to create an EFS you need to create a KMS key.

AWS Key Management Service (KMS) makes it easy for you to create and manage cryptographic keys and control their use across a wide range of AWS services and in your applications.

Add the following code to efs.tf


![Screenshot from 2022-11-18 13-06-35](https://user-images.githubusercontent.com/23356682/202701767-0a13bba5-5169-4237-ab27-f3c50786688a.png)


## Create MySQL RDS
Let us create the RDS itself using this snippet of code in rds.tf file:

![Screenshot from 2022-11-18 13-08-04](https://user-images.githubusercontent.com/23356682/202701901-44ea1b1d-5332-46f0-8724-080d97db9632.png)


Input the following code in your variables.tf file

```
variable "region" {
  type = string
  description = "The region to deploy resources"
}

variable "vpc_cidr" {
  type = string
  description = "The VPC cidr"
}

variable "enable_dns_support" {
  type = bool
}

variable "enable_dns_hostnames" {
  dtype = bool
}

variable "enable_classiclink" {
  type = bool
}

variable "enable_classiclink_dns_support" {
  type = bool
}

variable "preferred_number_of_public_subnets" {
  type        = number
  description = "Number of public subnets"
}

variable "preferred_number_of_private_subnets" {
  type        = number
  description = "Number of private subnets"
}

variable "name" {
  type    = string
  default = "ACS"

}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "ami" {
  type        = string
  description = "AMI ID for the launch template"
}

variable "keypair" {
  type        = string
  description = "key pair for the instances"
}

variable "account_no" {
  type        = number
  description = "the account number"
}

variable "db-username" {
  type        = string
  description = "RDS admin username"
}

variable "db-password" {
  type        = string
  description = "RDS master password"
}
```

Then add the following to your terraform.tfvars file


```
region = "us-east-1"

vpc_cidr = "172.16.0.0/16"

enable_dns_support = "true"

enable_dns_hostnames = "true"

enable_classiclink = "false"

enable_classiclink_dns_support = "false"

preferred_number_of_public_subnets = "2"

preferred_number_of_private_subnets = "4"

environment = "production"

ami = "<instance-ami>"

keypair = "<key-pair>"

# Ensure to change this to your acccount number
account_no = "<your-aaws-account-number>"

db-username = "<db-username>"

db-password = "<db-password>"

tags = {
  Enviroment      = "production" 
  Owner-Email     = "<account email>"
  Managed-By      = "<account_iam_user>"
  Billing-Account = "1234567890"
 
}
```

Then run a `terraform apply --auto-approve` your output should look this

![Screenshot from 2022-11-18 11-05-25](https://user-images.githubusercontent.com/23356682/202703341-769a7e65-b789-4c7a-8257-8903758eb5f0.png)
