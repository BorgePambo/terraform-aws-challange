variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  type        = string
}

variable "aws_vpc_name" {
  description = "Nome da VPC"
  type        = string
}

variable "aws_vpc_cidr" {
  description = "CIDR block da VPC"
  type        = string
}

variable "aws_vpc_azs" {
  description = "Lista de Availability Zones"
  type        = list(string)
}

variable "aws_vpc_private_subnets" {
  description = "Subnets privadas da VPC"
  type        = list(string)
}

variable "aws_vpc_public_subnets" {
  description = "Subnets públicas da VPC"
  type        = list(string)
}

variable "aws_eks_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "aws_eks_version" {
  description = "Versão do Kubernetes no EKS"
  type        = string
}

variable "aws_eks_managed_node_groups_instance_types" {
  description = "Tipos de instância do node group EKS"
  type        = list(string)
}

variable "aws_project_tags" {
  description = "Tags globais do projeto"
  type        = map(string)
}