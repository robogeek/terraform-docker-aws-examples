
resource "aws_ecs_task_definition" "todo" {
    family                   = "${data.terraform_remote_state.vpc.outputs.project_name}-todo-task"
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]

    // Doing this calculation results in this error:
    //    No Fargate configuration exists for given values.
    // Answer: https://code.thebur.net/2018/05/11/no-fargate-configuration-exists-for-given-values/
    // Basically, Fargate requires specific sizes.  Fargate is not helpful
    // which would be to round up.  Instead it requires that we specify
    // the exact size.
    cpu                      = 1024 //  var.notes_fargate_cpu * 3//  + var.userauth_fargate_cpu + var.redis_fargate_cpu
    memory                   = 2048 // var.notes_fargate_memory * 3 //  + var.userauth_fargate_memory + var.redis_fargate_memory
  
    container_definitions    = jsonencode(
        [ {
            name = "todo"
            image = var.todo_image
            cpu = var.todo_fargate_cpu
            memory = var.todo_fargate_memory
            networkMode = "awsvpc"
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    awslogs-group = "/ecs/${data.terraform_remote_state.vpc.outputs.project_name}-todo"
                    awslogs-region = data.terraform_remote_state.vpc.outputs.aws_region
                    awslogs-stream-prefix = "ecs"
                }
            }
            portMappings = [ {
                containerPort = 80
                hostPort = 80
            } ]
            environment = [ /* {
                    name = "REDIS_ENDPOINT"
                    value = "redis"
                }, */ {
                    name = "SEQUELIZE_CONNECT"
                    value = "models/sequelize-mysql-docker.yaml"
                }, {
                    name = "SEQUELIZE_DBNAME"
                    value = data.terraform_remote_state.db.outputs.tododb_name
                }, {
                    name = "SEQUELIZE_DBUSER"
                    value = data.terraform_remote_state.db.outputs.tododb_username
                }, {
                    name = "SEQUELIZE_DBPASSWD"
                    value = data.terraform_remote_state.db.outputs.tododb_userpasswd
                }, {
                    name = "SEQUELIZE_DBHOST"
                    value = data.terraform_remote_state.db.outputs.tododb-address
                } /* {
                    name = "NODE_DEBUG"
                    value = "redis"
                }, {
                    name = "DEBUG"
                    value = "todos:*,ioredis:*,socket.io:*,engine"
                }, */
            ]
        },
        /* {
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
            /* portMappings = [ {
                containerPort = var.redis_port
                hostPort = var.redis_port
            } ] * /
        } */ ]
    )
}

resource "aws_ecs_service" "todo" {
    name            = "${data.terraform_remote_state.vpc.outputs.project_name}-todo-service"
    cluster         = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.todo.arn
    desired_count   = var.todo_count
    launch_type     = "FARGATE"

    network_configuration {
        security_groups  = [ aws_security_group.todo_task.id ]
        subnets          = data.terraform_remote_state.vpc.outputs.private_subnets
        assign_public_ip = false
    }

    load_balancer {
        target_group_arn = module.alb.target_group_arns[0]
        container_name   = "todo"
        container_port   = "80"
    }

    depends_on = [
        aws_iam_role_policy_attachment.ecs_task_execution_role,
        aws_security_group.todo_task ]
}

resource "aws_security_group" "todo_task" {
    name        = "${data.terraform_remote_state.vpc.outputs.project_name}-todo-task-security-group"
    vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id 

    ingress {
        protocol        = "tcp"
        from_port       = 0
        to_port         = "80"
        cidr_blocks     = [ data.terraform_remote_state.vpc.outputs.vpc_cidr ]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

resource "aws_cloudwatch_log_group" "todo_log_group" {
    name              = "/ecs/${data.terraform_remote_state.vpc.outputs.project_name}-todo"
    retention_in_days = 30
}
