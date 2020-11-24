variable "tododb_id"         { default = "tododb" }
variable "tododb_name"       { default = "todo" }
variable "tododb_username"   { default = "todo" }
variable "tododb_userpasswd" { default = "passw0rd" }
variable "tododb_port"       { default = "3306" }

variable "configuration" {
    type = map(object({
        allocated_storage = number,
        storage_type = string,
        instance_class = string,
        tododb_id = string,
        tododb_name = string,
        tododb_username = string,
        tododb_userpasswd = string,
        skip_final_snapshot = bool,
        multi_az = bool
    }))
    default = {
        "DEV" = {
            allocated_storage = 20,
            storage_type = "gp2",
            instance_class = "db.t2.micro",
            tododb_id = "tododb",
            tododb_name = "todo",
            tododb_username = "todo",
            tododb_userpasswd = "passw0rd",
            // tododb_port = "3306",
            skip_final_snapshot = true,
            multi_az = true
        }
        // ...
    }
}