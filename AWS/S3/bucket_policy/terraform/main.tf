data "aws_iam_role" "admin_role" {name = "admin-role"}
data "aws_iam_role" "developer_role" {name = "developer-role"}
data "aws_iam_role" "operator_role" {name = "operator-role"}
data "aws_iam_user" "iam_user" {user_name = "test-user"}

module "storage" {
  source         = "./modules/s3"
  aws_account_id = data.aws_caller_identity.current.account_id

  admin_role_id     = data.aws_iam_role.admin_role.unique_id
  developer_role_id = data.aws_iam_role.developer_role.unique_id
  operator_role_id  = data.aws_iam_role.operator_role.unique_id
  iam_user_id       = data.aws_iam_user.iam_user.id
}