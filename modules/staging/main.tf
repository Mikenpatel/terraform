
# data "aws_apigatewayv2_api" "dev-aws-python-flask-api-project" {
#     api_id = var.api_id
 
# }

data "aws_api_gateway_rest_api" "my_rest_api" {
  name = "zappa-flask-dev"
}

output "REST-API-ID" {
    value=data.aws_api_gateway_rest_api.my_rest_api.id
}




resource "aws_acm_certificate" "example" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.hosted_zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn = aws_acm_certificate.example.arn
  validation_record_fqdns = [for record in aws_route53_record.example:record.fqdn]
}


resource "aws_api_gateway_domain_name" "example" {
  domain_name = var.domain_name
  certificate_arn = aws_acm_certificate_validation.example.certificate_arn
}

resource "aws_api_gateway_base_path_mapping" "example" {
  api_id      = data.aws_api_gateway_rest_api.my_rest_api.id
  domain_name = aws_api_gateway_domain_name.example.id
  stage_name       = var.api-stage-name
}



resource "aws_route53_record" "example2" {
  name    = aws_api_gateway_domain_name.example.domain_name
  type    = "A"
  zone_id = var.hosted_zone_id

alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.example.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.example.cloudfront_zone_id
  }


  #   weighted_routing_policy {
  #   weight = var.weight
  # }
  
  # geolocation_routing_policy{
    
  #   continent=var.continent
  # }

  latency_routing_policy {
    region=var.identifier_for_route53_record
  }

  set_identifier = var.identifier_for_route53_record
}


