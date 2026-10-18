cat > terraform/network/sandbox.tf <<'EOF'
# Sandbox VPC, created with the community VPC module (the common pattern).
module "sandbox_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "sandbox"
  cidr = "10.3.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.3.1.0/24", "10.3.2.0/24"]
  public_subnets  = ["10.3.101.0/24", "10.3.102.0/24"]
}
EOF