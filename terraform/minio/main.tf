resource "minio_s3_bucket" "raw_database" {
  provider = minio.tunnel

  bucket        = "raw-database"
  force_destroy = true
}

resource "minio_iam_user" "mulatta" {
  provider = minio.tunnel

  name          = "mulatta"
  force_destroy = true
}

resource "minio_iam_service_account" "rclone" {
  provider = minio.tunnel

  name        = "rclone"
  target_user = minio_iam_user.mulatta.name
}

resource "minio_iam_user_policy_attachment" "console_user_policy" {
  provider = minio.tunnel

  user_name   = minio_iam_user.mulatta.name
  policy_name = "readwrite"
}
