
resource "aws_ecs_task_definition" "redis" {
    family                   = "${data.terraform_remote_state.vpc.outputs.project_name}-redis-task"
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]

    cpu                      = 1024
    memory                   = 2048

    container_definitions    = jsonencode([
        {
            name = "redis"
            image = "redis"
            cpu = var.redis_fargate_cpu
            memory = var.redis_fargate_memory
            networkMode = "awsvpc"
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    awslogs-group = "/ecs/${data.terraform_remote_state.vpc.outputs.project_name}-redis"
                    awslogs-region = data.terraform_remote_state.vpc.outputs.aws_region
                    awslogs-stream-prefix = "ecs"
                }
            }
            portMappings = [ {
                containerPort = var.redis_port
                hostPort = var.redis_port
            } ]
        }
    ])
}

resource "aws_ecs_service" "redis" {
    name            = "${data.terraform_remote_state.vpc.outputs.project_name}-redis-service"
    cluster         = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.redis.arn
    desired_count   = var.redis_count
    launch_type     = "FARGATE"

    network_configuration {
        security_groups  = [ aws_security_group.redis_task.id ]
        subnets          = data.terraform_remote_state.vpc.outputs.private_subnets
        assign_public_ip = false
    }

    service_registries {
        registry_arn = aws_service_discovery_service.redis-service.arn
    }

    depends_on = [
        aws_iam_role_policy_attachment.ecs_task_execution_role,
        aws_security_group.redis_task ]
}

resource "aws_security_group" "redis_task" {
    name        = "${data.terraform_remote_state.vpc.outputs.project_name}-redis-task-security-group"
    vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id 

    ingress {
        protocol        = "tcp"
        from_port       = 0
        to_port         = var.redis_port
        cidr_blocks     = [ data.terraform_remote_state.vpc.outputs.vpc_cidr ]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

resource "aws_cloudwatch_log_group" "redis_log_group" {
    name              = "/ecs/${data.terraform_remote_state.vpc.outputs.project_name}-redis"
    retention_in_days = 30
}
