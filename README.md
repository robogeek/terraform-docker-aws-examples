# terraform-docker-aws-examples
Examples for using Terraform to deploy to AWS using Docker

This repository is a companion to the book [Deploying Docker Containers to AWS using Terraform](https://www.amazon.com/Deploying-Docker-Containers-using-Terraform-ebook/dp/B08WG578L1/)

This is the EC2-RDS branch, which builds on the [EC2-CLUSTER](https://github.com/robogeek/terraform-docker-aws-examples/tree/ec2-cluster) branch.  That branch demonstrated setting up an EC2 cluster, initializing Docker Swarm, and deploying a Docker application stack.

In the EC2-CLUSTER branch, the Docker stack included a MySQL instance to provide the database.

In the EC2-RDS branch, we instead use the AWS RDS service to provide the database.  This requires the following:

* Implement Terraform code to declare the RDS instance
* Modifications to the Docker Stack to utilize that instance

