variable "aws_vpc_region" {
  type        = string
  description = "Define the AWS region for VPC deployment"
  default     = "ap-southeast-1"
}

variable "aws_hvn_region" {
  type        = string
  description = "Define the AWS region for HVN deployment on HCP"
  default     = "ap-southeast-1"
}

variable "cluster_id" {
  type        = string
  description = "Cluster name to be used for HCP Consul and EKS deployments"
  default     = "dc1"
}

variable "hvn_id" {
  type        = string
  description = "HVN name to be used for HCP Consul HVN deployments"
  default     = "singapore-hvn"
}

variable "project_id" {
  type        = string
  description = "HCP Org Project id to be used"
  default     = "5594ca7c-efd8-4ba6-bdbb-007bcf95cd84"
}
