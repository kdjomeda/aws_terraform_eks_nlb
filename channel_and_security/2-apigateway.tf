resource "aws_cognito_user_pool" "mdw_cognito_auth" {
  name = "${local.common_name}-${local.mdw_product}-user-pool"
  password_policy {
    minimum_length = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers = true
    require_symbols = true
  }
}

resource "aws_cognito_user_pool_client" "mdw_cognito_auth" {
  name = "${local.common_name}-${local.mdw_product}-up-client"
  user_pool_id = aws_cognito_user_pool.mdw_cognito_auth.id
  allowed_oauth_flows_user_pool_client =  true
  allowed_oauth_flows = ["code","implicit"]
  allowed_oauth_scopes = ["aws.cognito.signin.user.admin"]
  supported_identity_providers = ["COGNITO"]
  explicit_auth_flows = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
  callback_urls = ["https://callbacks.gmfs.com"]
  prevent_user_existence_errors = "ENABLED"
}

resource "aws_cognito_user" "mdw_cognito_auth" {
  user_pool_id = aws_cognito_user_pool.mdw_cognito_auth.id
  username     = var.var_cognito_username
  password     = var.var_cognito_password
}

resource "aws_api_gateway_authorizer" "mdw_rest_api_gateway" {
  name        = "${local.common_name}-${local.mdw_product}-authorizer"
  rest_api_id = aws_api_gateway_rest_api.mdw_rest_api_gateway.id
  type = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.mdw_cognito_auth.arn]
}

resource "aws_api_gateway_vpc_link" "mdw_vpc_link" {
  name = "${local.common_name}-${local.mdw_product}-vpc-link"
  target_arns = [data.aws_lb.mdw_nlb.arn]
  tags = {
    Name = "${local.common_name}-${local.mdw_product}-vpc-link"
  }
}

# resource "aws_apigatewayv2_vpc_link" "mdw_vpc_link" {
#   name = "${local.common_name}-${local.mdw_product}-vpc-link"
#   security_group_ids = []
#   subnet_ids = local.private_subnets
# }
#
resource "aws_api_gateway_rest_api" "mdw_rest_api_gateway" {
  name = "${local.common_name}-${local.mdw_product}-apigateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# resource "aws_apigatewayv2_api" "mdw_http_api_gateway" {
#   name          = "${local.common_name}-${local.mdw_product}-apigateway"
#   protocol_type = "HTTP"
# }
#
resource "aws_api_gateway_resource" "mdw_rest_api_gateway" {
  parent_id = aws_api_gateway_rest_api.mdw_rest_api_gateway.root_resource_id
  path_part = "{proxy+}"
  rest_api_id = aws_api_gateway_rest_api.mdw_rest_api_gateway.id
}

resource "aws_api_gateway_method" "mdw_rest_api_gateway" {
  resource_id = aws_api_gateway_resource.mdw_rest_api_gateway.id
  rest_api_id = aws_api_gateway_rest_api.mdw_rest_api_gateway.id
  http_method = "ANY"
  request_parameters            = {"method.request.path.proxy" = true}
#   authorization = "NONE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.mdw_rest_api_gateway.id
}


resource "aws_api_gateway_integration" "mdw_http_api_gateway" {
  http_method = aws_api_gateway_method.mdw_rest_api_gateway.http_method
  resource_id = aws_api_gateway_resource.mdw_rest_api_gateway.id
  rest_api_id = aws_api_gateway_rest_api.mdw_rest_api_gateway.id
  type        = "HTTP_PROXY"
  uri = "${format("%s/{proxy}", "http://gmfs-ire-prod-nlb-mdw-bf9946d12311a39f.elb.eu-west-1.amazonaws.com")}"
  integration_http_method = "ANY"
  connection_type = "VPC_LINK"
  connection_id = aws_api_gateway_vpc_link.mdw_vpc_link.id
  passthrough_behavior     = "WHEN_NO_MATCH"
  request_parameters = { "integration.request.path.proxy" : "method.request.path.proxy" }

}

# resource "aws_apigatewayv2_integration" "mdw_http_api_gateway" {
#   api_id           = aws_apigatewayv2_api.mdw_http_api_gateway.id
#   integration_type = "HTTP_PROXY"
#   integration_uri = data.aws_lb_listener.mdw_nlb.arn
#   integration_method = "ANY"
#   connection_type = "VPC_LINK"
#   connection_id = aws_apigatewayv2_vpc_link.mdw_vpc_link.id
#   payload_format_version = "1.0"
#  depends_on = [
#                 aws_apigatewayv2_vpc_link.mdw_vpc_link,
#                 aws_apigatewayv2_api.mdw_http_api_gateway,
#                 data.aws_lb.mdw_nlb,
#                 data.aws_lb_listener.mdw_nlb
#              ]
# }


resource "aws_api_gateway_method_response" "mdw_http_api_response200" {
  http_method = aws_api_gateway_method.mdw_rest_api_gateway.http_method
  resource_id = aws_api_gateway_resource.mdw_rest_api_gateway.id
  rest_api_id = aws_api_gateway_rest_api.mdw_rest_api_gateway.id
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "mdw_http_api_gateway" {
  http_method = aws_api_gateway_method.mdw_rest_api_gateway.http_method
  resource_id = aws_api_gateway_resource.mdw_rest_api_gateway.id
  rest_api_id = aws_api_gateway_rest_api.mdw_rest_api_gateway.id
  status_code = aws_api_gateway_method_response.mdw_http_api_response200.status_code
  depends_on = [aws_api_gateway_integration.mdw_http_api_gateway]
}

resource "aws_api_gateway_deployment" "mdw_http_api_gateway" {

  rest_api_id = aws_api_gateway_rest_api.mdw_rest_api_gateway.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.mdw_rest_api_gateway.id,
      aws_api_gateway_method.mdw_rest_api_gateway.id,
      aws_api_gateway_integration.mdw_http_api_gateway.id,
      aws_api_gateway_method_response.mdw_http_api_response200.id
    ]))
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_api_gateway_integration.mdw_http_api_gateway]
}

resource "aws_api_gateway_stage" "mdw_http_api_gateway" {
  deployment_id = aws_api_gateway_deployment.mdw_http_api_gateway.id
  rest_api_id   = aws_api_gateway_rest_api.mdw_rest_api_gateway.id
  stage_name    = "template"

}
#
# resource "aws_apigatewayv2_route" "mdw_http_api_gateway" {
#   api_id    = aws_apigatewayv2_api.mdw_http_api_gateway.id
#   route_key = "ANY /{proxy+}"
#   target = "integrations/${aws_apigatewayv2_integration.mdw_http_api_gateway.id}"
#   depends_on = [aws_apigatewayv2_integration.mdw_http_api_gateway]
# }
#
#
#
# resource "aws_apigatewayv2_stage" "mdw_http_api_gateway" {
#   api_id = aws_apigatewayv2_api.mdw_http_api_gateway.id
#   name   = "$default"
#   auto_deploy = true
#   depends_on = [aws_apigatewayv2_api.mdw_http_api_gateway]
#
# }
#
# resource "aws_apigatewayv2_authorizer" "mdw_http_api_gateway" {
#   api_id          = aws_apigatewayv2_api.mdw_http_api_gateway.id
#   authorizer_type = "COGNITO_USER_POOLS"
#   name            = "${local.common_name}-${local.mdw_product}-authorizer"
# }
#
output "mdw_http_api_gateway_endpoint" {
  value = aws_api_gateway_deployment.mdw_http_api_gateway.invoke_url
}