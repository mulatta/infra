terraform {
  before_hook "reset old terraform state" {
    commands = ["init"]
    execute  = ["rm", "-f", ".terraform.lock.hcl"]
  }

  after_hook "lock state" {
    commands = ["init"]
    execute = ["tofu", "providers", "lock",
      "-platform=darwin_arm64",
      "-platform=darwin_amd64",
      "-platform=linux_arm64",
      "-platform=linux_amd64"
    ]
  }
}
