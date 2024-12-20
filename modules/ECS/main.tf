# ------- IAM Role for ECS Task Execution -------
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.environment}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    { Name = "${var.environment}-ecs-task-execution-role" }
  )
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/demo-site"
  retention_in_days = 30  # Adjust as needed

  tags = {
    Environment = "demo-site"
    Owner       = "DevOps"
  }
}

# ------- ECS Cluster -------
resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-ecs-cluster"

  tags = merge(
    var.tags,
    { Name = "${var.environment}-ecs-cluster" }
  )
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${var.environment}-backend-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions    = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      cpu       = var.container_cpu
      memory    = var.container_memory
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "DB_HOST", value = var.db_host },
        { name = "DB_NAME", value = var.db_name },
        { name = "DB_USER", value = tostring(var.db_user) },
        { name = "DB_PASSWORD", value = tostring(var.db_password) },
        { name = "DB_PORT", value = tostring(var.db_port) }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.log_group_name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = var.environment
        }
      }
    }
  ])

  tags = merge(
    var.tags,
    { Name = "${var.environment}-ecs-task-definition" }
  )
}


resource "aws_ecs_service" "main" {
  name            = "${var.environment}-backend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
    assign_public_ip = var.assign_public_ip
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn  # Reference the ALB target group ARN here
    container_name   = var.container_name
    container_port   = var.container_port
  }

  health_check_grace_period_seconds = 60
  tags = merge(
    var.tags,
    { Name = "${var.environment}-ecs-service" }
  )
}