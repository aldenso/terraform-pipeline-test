variable "location" {
  type    = string
  default = "eastus2"
}

variable "prefix" {
  type    = string
  default = "project01"
}

variable "vmsize" {
  type = map(any)
  default = {
    "small"  = "Standard_D2s_v3"
    "medium" = "Standard_D4s_v3"
    "large"  = "Standard_D8s_v3"
  }
}

variable "size" {
  type    = string
  default = "small"
}

variable "username" {
  type    = string
  default = "azureuser"
}

variable "password" {
  type    = string
  default = "myvery01Secure@ccess"
}

variable "distro" {
  type = string
}

variable "tag_name" {
  type    = string
  default = "ENV"
}

variable "tag_value" {
  type    = string
  default = "DESTROY"
}
