variable "cidr_block" {
  type = string
  default = "10.0.0.0/16"
  description = "cidr value"
}
variable "proj_name"{
    type = string
    default = "taint"
}

#ami id differs according to account and region, so we have to use data source but for simplification i have copied the ami Id
variable "ami" {
  type = string
  default = "ami-060f2cb962e997969"
}