cat > terraform/network/vpcs.tf <<'EOF'
# VPC address plan. Every VPC must use its own range so any two can be peered
# or attached to the Transit Gateway later.

resource "aws_vpc" "prod" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "prod" }
}

# Extra range for EKS pod IPs. The same range is reused in every cluster VPC on
# purpose: pod IPs are never routed outside their own VPC.
resource "aws_vpc_ipv4_cidr_block_association" "prod_pods" { # infradoctor: allow-overlap
  vpc_id     = aws_vpc.prod.id
  cidr_block = "100.64.0.0/16"
}

resource "aws_vpc" "staging" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "staging" }
}

resource "aws_vpc_ipv4_cidr_block_association" "staging_pods" { # infradoctor: allow-overlap
  vpc_id     = aws_vpc.staging.id
  cidr_block = "100.64.0.0/16"
}

resource "aws_vpc" "dev" {
  cidr_block           = "10.2.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "dev" }
}

resource "aws_vpc" "shared_services" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "shared-services" }
}
EOF