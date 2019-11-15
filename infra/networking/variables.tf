variable "azs" {
    default = ["ap-south-1a", "ap-south-1b", "ap-south-1b"]
}

variable "private_subnets" {
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
    default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

