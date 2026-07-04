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

variable "vm_name" {
  description = "仮想マシンの名前"
  type        = string
  default     = "vm-sample-linux"
}

variable "vm_size" {
  description = "仮想マシンのサイズ"
  type        = string
  default     = "Standard_B1s"   # 低コストな検証向けサイズ
}

variable "admin_username" {
  description = "SSHログイン用のユーザー名"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH公開鍵の内容（~/.ssh/id_rsa.pub の中身など）"
  type        = string
  sensitive   = true
}