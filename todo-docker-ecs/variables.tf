
variable "ecs-project-name" {
    default = "todo"
}

variable "configuration" {
    type = map(object({
        domain_root=string,
        service_discovery_namespace=string
    }))
    default = {
        "DEV" = {
            domain_root = "reikiworld.biz",
            service_discovery_namespace="dev.todo"
        }
        // ...
    }
}
