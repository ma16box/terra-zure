variable "resource_group_name" {
  description = "作成するリソースグループの名前"
  type        = string
  default     = "rg-github-actions-sample"
}

variable "location" {
  description = "デプロイ先リージョン"
  type        = string
  default     = "japanwest"
}