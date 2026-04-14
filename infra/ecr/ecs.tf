# =============================================================
# INFRAESTRUCTURA: ECS Cluster y Service
# Usa LabRole existente en AWS Academy Learner Lab
# =============================================================

data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

resource "aws_ecs_cluster" "techmarket" {
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = {
    Project     = "TechMarket"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_ecs_task_definition" "techmarket" {
  family                   = "techmarket-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.aws_iam_role.lab_role.arn

  container_definitions = jsonencode([{
    name  = "techmarket-app"
    image = "${aws_ecr_repository.techmarket.repository_url}:latest"
    portMappings = [{
      containerPort = 3000
      protocol      = "tcp"
    }]
    essential = true
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/techmarket"
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
        "awslogs-create-group"  = "true"
      }
    }
  }])

  tags = {
    Project   = "TechMarket"
    ManagedBy = "Terraform"
  }
}

resource "aws_ecs_service" "techmarket" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.techmarket.id
  task_definition = aws_ecs_task_definition.techmarket.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public.id]
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  tags = {
    Project     = "TechMarket"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}
