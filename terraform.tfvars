region = "us-east-1"

vpc_cidr = "172.16.0.0/16"

enable_dns_support = "true"

enable_dns_hostnames = "true"

enable_classiclink = "false"

enable_classiclink_dns_support = "false"

preferred_number_of_public_subnets = 2

preferred_number_of_private_subnets = 4

tags = {
  Environment      = "production"
  Owner-Email     = "ezekiel.umesi@gmail.com"
  Managed-By      = "Terraform"
  Billing-Account = "353928175117"
}

ami = "ami-0149b2da6ceec4bb0"

account_no = 353928175117

keypair = "example-1"

db-username = "acsdb"

db-password = "devopspbl"