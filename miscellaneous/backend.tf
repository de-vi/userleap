terraform {
  required_version = "= 0.12.29"
  backend "local" {
    path = "./tfstate_miscellaneous"
  }
}

