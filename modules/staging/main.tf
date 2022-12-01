
data "aws_api_gateway_rest_api" "my_rest_api" {
  name = "zappa-flask-${var.api-stage-name}"
}

resource "aws_acm_certificate" "example" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Environment = var.api-stage-name
  }

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
  domain_name              = var.domain_name
  regional_certificate_arn = aws_acm_certificate_validation.example.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


resource "aws_api_gateway_base_path_mapping" "example" {
  api_id      = data.aws_api_gateway_rest_api.my_rest_api.id
  domain_name = aws_api_gateway_domain_name.example.id
  stage_name       = var.api-stage-name
}

# Example DNS record using Route53.
# Route53 is not specifically required; any DNS host can be used.
resource "aws_route53_record" "example2" {
  name    = aws_api_gateway_domain_name.example.domain_name
  type    = "A"
  zone_id = var.hosted_zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.example.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.example.regional_zone_id
  }
 
  #  geolocation_routing_policy{
  #   continent=var.continent
  #   # country="CA"
  # }

    latency_routing_policy {
    region=var.identifier_for_route53_record
  }

  set_identifier = var.identifier_for_route53_record

}
