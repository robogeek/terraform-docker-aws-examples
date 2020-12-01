
variable "todo_image" {
    default = "robogeek/todo-app:first-dockerize-redis"
}


variable "todo_fargate_cpu"    { default = 256 }
variable "todo_fargate_memory" { default = 512 }
variable "todo_count"          { default = 1 }

variable "redis_fargate_cpu"    { default = 256 }
variable "redis_fargate_memory" { default = 512 }
variable "redis_count"          { default = 1 }
variable "redis_port"           { default = 6379 }

variable "ecs_task_execution_role_name" {
    description = "ECS task execution role name"
    default = "myEcsTaskExecutionRole"
}

variable "configuration" {
    type = map(object({
        domain_root=string
    }))
    default = {
        "DEV" = {
            domain_root = "reikiworld.biz"
        }
        // ...
    }
}
