output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private : s.id]
}

output "availability_zones_used" {
  value = local.azs
}

output "vpc_cidr" {
  value = var.vpc_cidr
}
