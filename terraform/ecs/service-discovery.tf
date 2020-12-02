
resource "aws_service_discovery_private_dns_namespace" "example" {
    name        = local.config.service_discovery_namespace
    description = "example"
    vpc         = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_service_discovery_service" "redis-service" {
    name = "redis"

    dns_config {
        namespace_id = aws_service_discovery_private_dns_namespace.example.id

        dns_records {
            ttl  = 10
            type = "A"
        }

        routing_policy = "MULTIVALUE"
    }

    health_check_custom_config {
        failure_threshold = 1
    }
}

