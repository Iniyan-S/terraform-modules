# variable "aws_profile" {
#   description = "The profile name configured in the file .aws/credentials"
#   type        = string
# }

# variable "aws_region" {
#   description = "The AWS Region where resources will be deployed"
#   type        = string
# }

# variable "environment_name" {
#   description = "The name of your environment"
#   type        = string

#   validation {
#     condition     = length(var.environment_name) < 23
#     error_message = "This variable is used for resource name concatenation. Ensure the value has less than 23 characters."
#   }
# }

# # variable "github_token" {
# #   description = "Personal access token for Github"
# #   type        = string
# #   sensitive   = true
# # }

# # variable "port_app_server" {
# #   description = "The port used by the server application"
# #   type        = number
# #   default     = 3001
# # }

# # variable "port_app_client" {
# #   description = "The port used by the client application"
# #   type        = number
# #   default     = 80
# # }

# # variable "buildspec_path" {
# #   description = "The path to the buildspec file"
# #   type        = string
# #   default     = "./Infrastructure/Templates/buildspec.yml"
# # }

# # variable "folder_path_server" {
# #   description = "The path to the server files"
# #   type        = string
# #   default     = "./Code/server/."
# # }

# # variable "folder_path_client" {
# #   description = "The path to the client files"
# #   type        = string
# #   default     = "./Code/client/."
# # }

# variable "container_name" {
#   description = "The container names for each ECS service"
#   type        = map(string)
#   default = {
#     server = "Container-server"
#       }
# }

# # variable "iam_role_name" {
# #   description = "The names of the IAM Roles for each service"
# #   type        = map(string)
# #   default = {
# #     devops        = "DevOps-Role"
# #     ecs           = "ECS-task-execution-Role"
# #     ecs_task_role = "ECS-task-Role"
# #     codedeploy    = "CodeDeploy-Role"
# #   }
# # }

# # variable "repository_owner" {
# #   description = "The owner of the Github repository"
# #   type        = string
# # }

# # variable "repository_name" {
# #   description = "The name of the Github repository"
# #   type        = string
# # }

# # variable "repository_branch" {
# #   description = "The branch of the Github repository that triggers CodePipeline execution"
# #   type        = string
# #   default     = "main"
# # }

# variable "project_name" {
#   description = "The name of the project"
#   type        = string
# }

# variable "vpc_cidr" {
#   description = "CIDR block for the VPC"
#   type        = string
# }

# variable "tags" {
#   description = "Tags to apply to all resources"
#   type        = map(string)
# }

# variable "key_name" {
#   description = "The name of the SSH key pair to be used for EC2 instances"
#   type        = string
#   default     = "skewb-demo"  # You can set a default value or leave it empty for manual input
# }

variable "aws_profile" {
  description = "The profile name configured in the file .aws/credentials"
  type        = string
  default     = "excelencia"
}

variable "aws_region" {
  description = "The AWS Region where resources will be deployed"
  type        = string
  default     = "eu-west-2"
}

variable "environment" {
  description = "The name of your environment"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "skewb-novus-demo"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    "Environment" = "demo-site"
    "Project"     = "skewb-novus-demo"
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "key_name" {
  description = "The EC2 Key pair name to be used"
  type        = string
  default     = "skewb-demo" 
}

# variable "environment" {
#   description = "The environment for the resources (e.g., dev, staging, prod)"
#   type        = string
# }



