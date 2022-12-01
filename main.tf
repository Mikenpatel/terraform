provider "aws"{
  region="ca-central-1"
}

# provider "aws" {
#   alias  = "east-1"
#   region = "us-east-1"
# }

data "aws_region" "current" {}

module "us-east-1-serverless" {
 # source="./modules/staging"
  source="https://github.com/Mikenpatel/terraform/tree/main/modules/staging"

  domain_name = "www.mikenpatel.click"
  hosted_zone_id = "Z02894083S0UP56WO6XYT"
  # weight = 50
  #continent="SA"

  identifier_for_route53_record = "ca-central-1"
  api-stage-name="stag"

  # providers = {
  #   aws=aws
  #   aws.east-1 = aws.east-1
  #  }


  
  # api_id = "hyuytvtnz3"
  
  # # Backend Parameter
  # s3_bucket_name = "terraform-s3-state-file"
  # s3_bucket_path = "global/s3/sa-east-1/terraform.tfstate"
  # # backend_region=data.aws_region.current

  # aws_dynamodb_table_name = "mutli-region-application-locks"

}



# terraform{
#     backend "s3"{
#         bucket="terraform-s3-state-file-for-multi-region-application"
#         key="global/s3/us-east-1/terraform.tfstate"
#         region = "us-east-1"
#         dynamodb_table = "mutli-region-application-locks"
#         encrypt = true
#     }
# }
