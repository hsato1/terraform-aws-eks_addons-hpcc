admin = {
  name  = "Hiroki Sato"
  email = "hirosato@lexisnexis.com"
}

networking =  {
    cidr_block      = "10.0.0.0/16"
    region          = "us-east-1"
    vpc_name        = "custom-vpc"
    azs             = ["us-east-1a", "us-east-1b"]
    public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets = ["10.0.3.0/24"]
    nat_gateways    = true
}

path = "/Users/satouhiroshiki/.aws"
profile = "ida-cloud-ops"
region = "us-east-1"
