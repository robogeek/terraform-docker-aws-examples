# terraform-docker-aws-examples
Examples for using Terraform to deploy to AWS using Docker

This repository is a companion to the book [Deploying Docker Containers to AWS using Terraform](https://www.amazon.com/Deploying-Docker-Containers-using-Terraform-ebook/dp/B08WG578L1/)

This is the MAIN branch which contains no code.  Everything of interest is in the following branches:

* [VPC](https://github.com/robogeek/terraform-docker-aws-examples/tree/vpc) - Demonstrates setting up a simple VPC on AWS
* [EC2-CLUSTER](https://github.com/robogeek/terraform-docker-aws-examples/tree/ec2-cluster) - Demonstrates setting up an EC2 cluster, initializing Docker Swarm, and deploying a Docker application stack
* [EC2-RDS](https://github.com/robogeek/terraform-docker-aws-examples/tree/ec2-rds) - Demonstrates using an AWS RDS instance to supply the database to the Docker application stack
* [ENVIRONMENTS](https://github.com/robogeek/terraform-docker-aws-examples/tree/environments) - Demonstrates several advanced Terraform features
* [TERRAFORM-ECS](https://github.com/robogeek/terraform-docker-aws-examples/tree/terraform-ecs) - Demonstrates several advanced Terraform features
* [DOCKER-ECS](https://github.com/robogeek/terraform-docker-aws-examples/tree/docker-ecs) - Demonstrates deployment direct to ECS using Docker Compose files

