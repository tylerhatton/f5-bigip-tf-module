terraform {
  required_version = ">= 0.12.21"

  required_providers {
    aws      = ">= 2.68"
    random   = ">= 2.3"
    template = ">= 2.1"
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.4.0"
    }
  }
}