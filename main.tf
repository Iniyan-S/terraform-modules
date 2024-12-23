/*===========================
          Root file
===========================*/

# terraform {
#   # required_version = "~>1.0.0"

#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#       version = "~>5.0"
#     }
#   }
# }


# ------- Providers -------
provider "aws" {
  region  = var.aws_region
  # profile = var.aws_profile # Optional if you want Terraform to use an AWS CLI profile
  # assume_role {
  #   role_arn     = "arn:aws:iam::489692785864:role/TerraformDeployRole"
  #   session_name = "terraform-session"
  # }
}

# ------- Random numbers intended to be used as unique identifiers for resources -------
resource "random_id" "RANDOM_ID" {
  byte_length = 2
}

# ------- Account ID -------
data "aws_caller_identity" "id_current_account" {}

#------- Networking -------
module "vpc" {
  source             = "./modules/Networking" # Path to the VPC module folder
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_count = 2
  private_subnet_count = 2
  subnet_prefix      = 8
  environment        = "demo-site"
}

#------- ECS Fargate Module -------
# module "ecs_fargate" {
#   source              = "./modules/ECS"
#   environment         = "demo-site"
#   tags                = { Environment = "demo-site", Owner = "DevOps" }
#   desired_count       = 2
#   task_cpu            = "512"
#   task_memory         = "1024"
#   container_name      = "my-container"
#   container_image     = "489692785864.dkr.ecr.us-east-1.amazonaws.com/nginx:latest"
#   container_cpu       = 256
#   container_memory    = 512
#   container_port      = 80
#   security_groups   = [module.ecs_security_group.sg_id]
#   # lb_security_groups  = module.alb_security_group.sg_id
#   subnets             = module.vpc.private_subnets
#   # vpc_id              = module.vpc.vpc_id
#   max_task_count      = 5
#   min_task_count      = 1
#   assign_public_ip    = true
#   aws_region          = "us-east-1"
#   # ssl_certificate_arn = ""  # Add the ARN of your SSL certificate if you need HTTPS
#   alb_target_group_arn = module.alb.alb_target_group_arn
# }
# output "alb_target_group_arn" {
#   value = module.alb.alb_target_group_arn
# }

module "rds" {
  source               = "./modules/RDS"
  environment          = "demo-site"
  vpc_id               = module.vpc.vpc_id
  private_subnets      = module.vpc.private_subnets
  rds_security_group   = module.rds_security_group.sg_id
  allocated_storage    = 400
  max_allocated_storage = 500
  storage_type         = "gp3"
  engine               = "postgres"
  engine_version       = "14.12"
  instance_class       = "db.t3.micro"
  # db_name              = "demo-site-rds-new"
  db_user             = "postgres"
  db_password            = "mysecurepassword"
  
  publicly_accessible  = false
  multi_az             = false
  backup_retention_period = 7
  snapshot_identify    = "arn:aws:rds:eu-west-2:489692785864:snapshot:ecs-demo"

  tags = {
    Name        = "${var.environment}-rds"
    Environment = var.environment
  }
}


#ALB Module for creating an Application Load Balancer and target groups
module "alb" {
  source              = "./modules/ALB"  # Path to your ALB module
  create_alb          = true
  create_target_group = true
  name                = "demo-site-alb"
  subnets             = module.vpc.public_subnets  # Use the subnets from VPC
  security_group      = module.alb_security_group.sg_id  # Use the security group for ECS
  vpc                 = module.vpc.vpc_id  # The VPC where the ALB should be created
  protocol            = "HTTP"  # Protocol for the ALB
  port                = 80  # Port for ALB to listen on
  tg_type             = "ip"  # Type of target group (use "ip" for Fargate)
  health_check_path   = "/health"  # Path for health checks
  health_check_port   = "3000"  # Port for health checks
  
}

module "ecs_fargate" {
  source                = "./modules/ECS"
  environment           = "demo-site"
  db_host               = module.rds.rds_endpoint
  db_name               = "demo-site-rds-new"
  db_user               = module.rds.rds_username
  db_password           = module.rds.rds_password
  db_port               = 5432
  tags                  = { Environment = "demo-site", Owner = "DevOps" }
  desired_count         = 1
  task_cpu              = "512"
  task_memory           = "1024"
  container_name        = "demo-site-backend-container"
  container_image       = "489692785864.dkr.ecr.eu-west-2.amazonaws.com/connectme-backend:latest"
  container_cpu         = 512
  container_memory      = 1024
  container_port        = 3000
  host_port             = 3000
  security_groups       = [module.ecs_security_group.sg_id]
  subnets               = module.vpc.private_subnets
  max_task_count        = 2
  min_task_count        = 1
  assign_public_ip      = true
  aws_region            = "eu-west-2"
  alb_target_group_arn  = module.alb.target_group_arn

  # Logging configuration
  log_group_name        = "/ecs/demo-site"
}



# # ECS Fargate Frontend (React) Service
# module "ecs_fargate_frontend" {
#   source                = "./modules/ECS"  # Path to your ECS module
#   environment           = "demo-site"  # Environment name
#   tags                  = { Environment = "demo-site", Owner = "DevOps" }
#   desired_count         = 1  # Desired number of instances
#   task_cpu              = "512"  # CPU allocation for the task
#   task_memory           = "1024"  # Memory allocation for the task
#   container_name        = "connectme-react"  # Container name for frontend service
#   container_image       = "489692785864.dkr.ecr.eu-west-2.amazonaws.com/connectme-react:latest"  # ECR image URL for React app
#   container_cpu         = 256  # CPU allocation for the container
#   container_memory      = 512  # Memory allocation for the container
#   container_port        = 80  # Port the container will listen on
#   host_port             = 80  # Port on the host machine (Fargate)
#   security_groups       = [module.ecs_security_group.sg_id]  # ECS security group
#   subnets               = module.vpc.private_subnets  # Private subnets for the service
#   max_task_count        = 2  # Maximum number of tasks to run
#   min_task_count        = 1  # Minimum number of tasks to run
#   assign_public_ip      = true  # Whether to assign a public IP
#   aws_region            = "eu-west-2"  # AWS region
#   alb_target_group_arn  = module.alb.target_group_arn  # Target group ARN for ALB routing
# }

# # ECS Fargate Backend (Node.js) Service
# module "ecs_fargate_backend" {
#   source                = "./modules/ECS"  # Path to your ECS module
#   environment           = "demo-site"  # Environment name
#   tags                  = { Environment = "demo-site", Owner = "DevOps" }
#   desired_count         = 1  # Desired number of instances
#   task_cpu              = "512"  # CPU allocation for the task
#   task_memory           = "1024"  # Memory allocation for the task
#   container_name        = "connectme-backend"  # Container name for backend service
#   container_image       = "489692785864.dkr.ecr.eu-west-2.amazonaws.com/connectme-backend:latest"  # ECR image URL for Node.js app
#   container_cpu         = 256  # CPU allocation for the container
#   container_memory      = 512  # Memory allocation for the container
#   container_port        = 3000  # Port the container will listen on
#   host_port             = 3000  # Port on the host machine (Fargate)
#   security_groups       = [module.ecs_security_group.sg_id]  # ECS security group
#   subnets               = module.vpc.private_subnets  # Private subnets for the service
#   max_task_count        = 2  # Maximum number of tasks to run
#   min_task_count        = 1  # Minimum number of tasks to run
#   assign_public_ip      = true  # Whether to assign a public IP
#   aws_region            = "eu-west-2"  # AWS region
#   alb_target_group_arn  = module.alb.target_group_arn  # Target group ARN for ALB routing
# }

# ------- Security Groups -------

module "rds_security_group" {
  source      = "./modules/SecurityGroup"
  name        = "${var.environment}-rds-sg"
  description = "Allow access to RDS PostgreSQL"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description      = "Allow inbound access on PostgreSQL port (5432)"
      from_port        = 5432
      to_port          = 5432
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups  = [module.ecs_security_group.sg_id]  # Allow access from ECS security group
      self             = true
    }
  ]

  egress_rules = [
    {
      description      = "Allow outbound traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
  environment   = "demo-site"
  tags = {
    Name        = "${var.environment}-rds-sg"
    Environment = var.environment
  }
}

module "redis_sg" {
  source      = "./modules/SecurityGroup"
  name        = "${var.environment}-redis-sg"
  description = "Security group for Redis"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description      = "Allow Redis access"
      from_port        = 6379
      to_port          = 6379
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups  = [module.ecs_security_group.sg_id]  # Allow access from ECS security group
      self             = false
    }
  ]

  egress_rules = [
    {
      description      = "Allow all outbound traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
  environment           = "demo-site"
  tags = {
    Name        = "${var.environment}-redis-sg"
    Environment = var.environment
  }
}

# module "ecs_security_group" {
#   source      = "./modules/SecurityGroup"
#   name        = "${var.environment}-ecs-service-sg"
#   description = "Allow access to ECS services"
#   vpc_id      = module.vpc.vpc_id

#   ingress_rules = [
#     {
#       description      = "Allow inbound access from ALB on port 80"
#       from_port        = 80
#       to_port          = 80
#       protocol         = "tcp"
#       security_groups  = [module.alb_security_group.sg_id]  # ALB security group ID
#       cidr_blocks      = []  # No CIDR block, only ALB security group
#     },
#     # {
#     #   description      = "Allow inbound access from ALB on port 3000"
#     #   from_port        = 3000
#     #   to_port          = 3000
#     #   protocol         = "tcp"
#     #   security_groups  = [module.alb_security_group.sg_id]  # ALB security group ID
#     #   cidr_blocks      = []  # No CIDR block, only ALB security group
#     # }
#   ]

#   egress_rules = [
#     {
#       description      = "Allow all outbound traffic"
#       from_port        = 0
#       to_port          = 0
#       protocol         = "-1"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#     }
#   ]

#   environment = "demo-site"

#   tags = {
#     Name        = "${var.environment}-ecs-service-sg"
#     Environment = var.environment
#   }
# }


# module "alb_security_group" {
#   source      = "./modules/SecurityGroup"
#   name        = "${var.environment}-alb-sg"
#   description = "Controls access to the ALB"
#   vpc_id      = module.vpc.vpc_id

#   ingress_rules = [
#     {
#       description      = "Allow HTTP traffic on port 80"
#       from_port        = 80
#       to_port          = 80
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]  # Allow access from all sources
#       ipv6_cidr_blocks = []
#       security_groups  = []
#     }
#   ]

#   egress_rules = [
#     {
#       description      = "Allow all outbound traffic"
#       from_port        = 0
#       to_port          = 0
#       protocol         = "-1"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#     }
#   ]

#   environment = "demo-site"

#   tags = {
#     Name        = "${var.environment}-alb-sg"
#     Environment = var.environment
#   }
# }

module "alb_security_group" {
  source      = "./modules/SecurityGroup"
  environment = "demo-site"
  name        = "${var.environment}-alb-sg"
  description = "Controls access to the ALB"
  vpc_id      = module.vpc.vpc_id
  ingress_rules = []  // No inline ingress rules
  egress_rules  = []  // No inline egress rules
  tags = {
    Name        = "${var.environment}-alb-sg"
    Environment = var.environment
  }
}

module "ecs_security_group" {
  source      = "./modules/SecurityGroup"
  environment = "demo-site"
  name        = "${var.environment}-ecs-service-sg"
  description = "Allows access to ECS services"
  vpc_id      = module.vpc.vpc_id
  ingress_rules = []  // No inline ingress rules
  egress_rules  = []  // No inline egress rules
  tags = {
    Name        = "${var.environment}-ecs-service-sg"
    Environment = var.environment
  }
}

// ALB Security Group: Allow HTTP traffic from public sources
resource "aws_security_group_rule" "alb_ingress_http" {
  description       = "Allow HTTP traffic on port 80 from public sources"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.alb_security_group.sg_id
}

// ALB Security Group: Allow outbound traffic to ECS on port 3000
resource "aws_security_group_rule" "alb_egress_to_ecs" {
  description              = "Allow outbound traffic from ALB to ECS on port 3000"
  type                     = "egress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = module.alb_security_group.sg_id
  source_security_group_id = module.ecs_security_group.sg_id
}

// ECS Security Group: Allow inbound traffic from ALB on port 3000
resource "aws_security_group_rule" "ecs_ingress_from_alb" {
  description              = "Allow inbound traffic from ALB to ECS on port 3000"
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = module.ecs_security_group.sg_id
  source_security_group_id = module.alb_security_group.sg_id
}

// ECS Security Group: Allow all outbound traffic
resource "aws_security_group_rule" "ecs_egress_all" {
  description       = "Allow all outbound traffic from ECS"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = module.ecs_security_group.sg_id
}

# ------- SSH Security Group -------

module "ssh_sg" {
  source      = "./modules/SecurityGroup"
  name        = "${var.environment}-ssh-sg"
  description = "Security group to allow SSH access"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description      = "Allow SSH access"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"] # Replace with a restricted IP range for better security
      ipv6_cidr_blocks = []
      security_groups  = []
      self             = false
    }
  ]

  egress_rules = [
    {
      description      = "Allow all outbound traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
  environment           = "demo-site"
  tags = {
    Name        = "${var.environment}-ssh-sg"
    Environment = var.environment
  }
}

#------- EC2 Instances for Redis and MongoDB -------

module "redis_instance" {
  source        = "./modules/EC2"
  ami_id        = "ami-03ceeb33c1e4abcd1"  # Replace with actual AMI ID
  instance_name = "demo-site-redis-ec2"
  instance_type = "t3.medium"
  key_name      = var.key_name
  security_group_ids = [
    module.ssh_sg.sg_id,  # SSH security group
    module.redis_sg.sg_id  # Redis security group
  ]
  subnet_id     = module.vpc.public_subnets[0]
  user_data     = file("./userdata/redis_user_data.txt")  # Ensure this script exists
}




# module "mongodb_instance" {
#   source        = "./modules/EC2"
#   ami_id        = "ami-03ceeb33c1e4abcd1"  # Replace with actual AMI ID
#   instance_name = "demo-site-mongodb-ec2"
#   instance_type = "t2.micro"
#   key_name      = var.key_name
#   security_group_ids = [
#     module.ssh_sg.sg_id,  # SSH security group
#     module.mongodb_sg.sg_id  # MongoDB security group
#   ]
#   subnet_id     = module.vpc.public_subnets[1]
#   user_data     = file("./userdata/mongodb_user_data.txt")  # Ensure this script exists
# }




module "s3_bucket" {
  source = "./modules/S3"

  bucket_name               = "demo-site-s3"
  # force_destroy             = true
  # versioning_enabled        = true
  # sse_algorithm             = "AES256"
  # # logging_bucket_name       = "my-logging-bucket"
  # lifecycle_noncurrent_days = 30
  # tags = {
  #   Environment = "demo-site"
  #   }
}

