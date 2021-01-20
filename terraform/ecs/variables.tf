
variable "todo_image" {
    default = "robogeek/todo-app:first-dockerize-redis"
}

variable "todo_fargate_cpu"     { default = 256 }
variable "todo_fargate_memory"  { default = 512 }
variable "todo_count"           { default = 1 }
variable "todo_maximum_percent" { default = 200 }
variable "todo_minimum_healthy" { default = 10  }

variable "ecs_task_execution_role_name" {
    description = "ECS task execution role name"
    default = "myEcsTaskExecutionRole"
}

variable "domain_root" { }
variable "bare_domain" { }
