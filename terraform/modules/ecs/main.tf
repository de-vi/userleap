resource "aws_iam_role" "ecsInstanceRole" {
  name               = "ecsInstanceRole"
  assume_role_policy = var.ecsInstanceRoleAssumeRolePolicy
}

resource "aws_iam_role_policy" "ecsInstanceRolePolicy" {
  name   = "ecsInstanceRolePolicy"
  role   = aws_iam_role.ecsInstanceRole.id
  policy = var.ecsInstancerolePolicy
}

/*
 * Create ECS IAM Service Role and Policy
 */
resource "aws_iam_role" "ecsServiceRole" {
  name               = "ecsServiceRole"
  assume_role_policy = var.ecsServiceRoleAssumeRolePolicy
}

resource "aws_iam_role_policy" "ecsServiceRolePolicy" {
  name   = "ecsServiceRolePolicy"
  role   = aws_iam_role.ecsServiceRole.id
  policy = var.ecsServiceRolePolicy
}

resource "aws_iam_instance_profile" "ecsInstanceProfile" {
  name = "ecsInstanceProfile"
  role = aws_iam_role.ecsInstanceRole.name
}

resource "aws_ecs_cluster" "app_ecs_cluster" {
  name = "app-ecs-cluster"
}

resource "aws_ecs_task_definition" "app_tsdf" {
  family                = "app_tsdf"
  container_definitions = file("${path.module}/service.json")
}

resource "aws_ecs_service" "app" {
  name            = "app-ecs"
  cluster         = aws_ecs_cluster.app_ecs_cluster.id
  task_definition = aws_ecs_task_definition.app_tsdf.arn
  desired_count   = 1
  iam_role        = aws_iam_role.ecsServiceRole.arn
  depends_on      = [aws_iam_role_policy.ecsServiceRolePolicy]

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "app"
    container_port   = 5000
  }

}
