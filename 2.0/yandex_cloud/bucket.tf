resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.instances.id
  description        = "Static access key for object storage"
}

resource "yandex_storage_bucket" "netologybucket25031996" {
  access_key    = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  acl           = "public-read"
  bucket        = "netologybucket25031996"
  force_destroy = "true"
  lifecycle_rule {
    prefix  = "config/"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "COLD"
    }

    noncurrent_version_expiration {
      days = 90
    }
  }
  website {
    index_document = "index.html"
  }
}

resource "yandex_storage_object" "image-object" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  acl        = "public-read"
  bucket     = "netologybucket25031996"
  key        = "fox.jpg"
  source     = "/home/glisikh/cloud_pro-netology/2.0/yandex_cloud/files/fox.jpg"
  depends_on = [
    yandex_storage_bucket.netologybucket25031996,
  ]
}
