output "bucket_name" {
  description = "Created bucket name"
  value       = minio_s3_bucket.raw_database.bucket
}

output "mulatta_credentials" {
  description = "Console user access credentials"
  value = {
    username    = minio_iam_user.mulatta.name
    console_access_key  = minio_iam_user.mulatta.name
    console_secret_key  = minio_iam_user.mulatta.secret
    service_access_key = minio_iam_service_account.rclone.access_key
    service_secret_key = minio_iam_service_account.rclone.secret_key
  }
  sensitive = true
}

output "mulatta_service_credentials" {
  description = "Service account access credentials"
  value = {

  }
  sensitive = true
}

output "minio_endpoint" {
  description = "MinIO endpoint URL"
  value       = "http://${module.minio_tunnel.host}:${module.minio_tunnel.port}"
}
