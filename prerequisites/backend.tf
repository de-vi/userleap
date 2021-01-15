terraform {
  required_version = "= 0.13.6"
  backend "local" {
    path = "./.tfstate_prerequisites"
  }
}

