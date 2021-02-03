# Idea - Generate overlay for docker-compose.yml from terraform data

locals {
    /*
    overlay = yamlencode({
        x-aws-cloudformation = {
            Resources = {
                WordpressTCP80TargetGroup = {
                    Properties = {
                        HealthCheckPath = "/wp-login.php",
                        Matcher = {
                            HttpCode = "200-499"
                        }
                    }
                }
            }
        }
    })
    */
    /* */
    overlay = yamlencode({
        x-aws-cloudformation: {
            Resources = local.resources
        }
    })
    health-check-overlay = {
        WordpressTCP80TargetGroup = {
            Properties = {
                HealthCheckPath = "/wp-login.php",
                Matcher = {
                    HttpCode = "200-499"
                }
            }
        }
    }
    efs-ap-name = "wpfs-ec2"
    efs-access-point = {
        WpfsAccessPointEC2 = {
            Properties = {
                AccessPointTags = [
                    { Key = "com.docker.compose.project",
                      Value = "wordpress-docker-ecs" },
                    { Key = "Name",
                      Value = local.efs-ap-name }
                ]
                FileSystemId = aws_efs_file_system.wordpress.id
                PosixUser = {
                    Uid = "33",
                    Gid = "33"
                }
                RootDirectory = {
                    CreationInfo = {
                        OwnerGid = "33"
                        OwnerUid = "33"
                        Permissions = "777"
                    }
                }
            }
            Type = "AWS::EFS::AccessPoint"
        }
    }
    // Produce: WpfsNFSMountTargetOnSubnetNNNNNNNNNN
    // Where: NNNNN is the Subnet ID
    // Each item is in this format: subnet-34e32369
    id-codes = [for id in module.default-vpc.default_vpc_subnets : split("-", id)[1] ]
    target-names = [for code in local.id-codes : "WpfsNFSMountTargetOnSubnet${code}"  ]
    # Produce a map targeting each WpfsNFSMountTarget
    target-overlays = { for target in local.target-names : target => {
        Properties = {
            SecurityGroups = [
                { Ref = "DefaultNetwork" },
                aws_security_group.allow-nfs.id
            ]
        }
    } }
    # Take all items for resources, merging everything into one map
    resources = merge(local.health-check-overlay, 
                      local.efs-access-point,
                      local.target-overlays)
    /* */
}

