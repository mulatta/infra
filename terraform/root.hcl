terraform {
  before_hook "reset_old_terraform_state" {
    commands     = ["init"]
    execute      = ["rm", "-f", ".terraform.lock.hcl"]
    run_on_error = true
  }
}

locals {
  module_name         = basename(get_terragrunt_dir())
  terraform_state_key = "${local.module_name}/terraform.tfstate"
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {
    bucket                      = "tfstate"
    key                         = "${local.terraform_state_key}"
    region                      = "us-east-1"
    endpoints                   = { s3 = "https://s3.sjanglab.org" }
    
    use_path_style              = true
    skip_credentials_validation = true
    skip_requesting_account_id = true
    skip_metadata_api_check = true
    skip_region_validation = true    
    encrypt = false
  }
}
EOF
}

