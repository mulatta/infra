output "uniprot-bucket" {
  description = "Uniprot database bucket"
  value       = minio_s3_bucket.uniprot.bucket
}

output "ncbi-bucket" {
  description = "NCBI database bucket"
  value       = minio_s3_bucket.ncbi.bucket
}

output "tfstate-bucket" {
  description = "tfstate bucket"
  value       = minio_s3_bucket.tfstate.bucket
}

output "mulatta_credentials" {
  description = "Console user access credentials"
  value = {
    username           = minio_iam_user.mulatta.name
    console_access_key = minio_iam_user.mulatta.name
    console_secret_key = minio_iam_user.mulatta.secret
    service_access_key = minio_iam_service_account.rclone.access_key
    service_secret_key = minio_iam_service_account.rclone.secret_key
  }
  sensitive = true
}

output "buildbot_credentials" {
  value = {
    username           = minio_iam_user.buildbot.name
    console_access_key = minio_iam_user.buildbot.name
    console_secret_key = minio_iam_user.buildbot.secret
    service_access_key = minio_iam_service_account.buildbot.access_key
    service_secret_key = minio_iam_service_account.buildbot.secret_key
  }
  sensitive = true
}
