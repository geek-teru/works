resource "aws_cognito_user_pool" "example" {
  name = "example_user_pool"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
  }
}

resource "aws_cognito_user_pool_client" "example" {
  name         = "example_user_pool_client"
  user_pool_id = aws_cognito_user_pool.example.id
  generate_secret = false

  allowed_oauth_flows = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes = ["email", "openid", "profile"]
  
  callback_urls = ["http://localhost:3000/"]
  logout_urls  = ["http://localhost:3000/"]
  
  supported_identity_providers = ["COGNITO"]

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

resource "aws_cognito_user_pool_domain" "example" {
  domain       = "example-app-domain"
  user_pool_id = aws_cognito_user_pool.example.id
}
