resource "aws_iam_role_policy_attachment" "task-attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = "ecsTaskRole"
}

resource "aws_ecs_task_definition" "body-record-task" {
  container_definitions = jsonencode([{
    cpu = 0
    environment = [{
      name  = "AWS_BUCKET"
      value = "body-record"
      }, {
      name  = "AWS_REGION"
      value = "us-east-1"
      }, {
      name  = "RAILS_ENV"
      value = "production"
    }]
    environmentFiles = []
    essential        = true
    image            = "110550326393.dkr.ecr.us-east-1.amazonaws.com/body-record-rails:latest"
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group  = "true"
        awslogs-group         = "/ecs/body_record_task"
        awslogs-region        = "us-east-1"
        awslogs-stream-prefix = "ecs"
      }
      secretOptions = []
    }
    mountPoints = []
    name        = "body_record"
    portMappings = [{
      appProtocol   = "http"
      containerPort = 3000
      hostPort      = 3000
      name          = "body_record-3000-tcp"
      protocol      = "tcp"
    }]
    secrets = [{
      name      = "API_DOMAIN"
      valueFrom = "/api/domain"
      }, {
      name      = "AWS_ACCESS_KEY_ID"
      valueFrom = "/ses/accesskey/id"
      }, {
      name      = "AWS_S3_ACCESS_KEY_ID"
      valueFrom = "/s3/accesskey/id"
      }, {
      name      = "AWS_S3_SECRET_ACCESS_KEY"
      valueFrom = "/s3/accesskey/secret"
      }, {
      name      = "AWS_SECRET_ACCESS_KEY"
      valueFrom = "/ses/accesskey/secret"
      }, {
      name      = "DATABASE_HOST"
      valueFrom = "/rds/host"
      }, {
      name      = "DATABASE_PASSWORD"
      valueFrom = "/rds/password"
      }, {
      name      = "DATABASE_PRODUCTION_NAME"
      valueFrom = "/rds/name"
      }, {
      name      = "DATABASE_USER_NAME"
      valueFrom = "/rds/username"
      }, {
      name      = "DEVELOPMENT_MAIL_TO"
      valueFrom = "/mail/to"
      }, {
      name      = "HOST"
      valueFrom = "/mail/host"
      }, {
      name      = "MAIL_FROM"
      valueFrom = "/mail/from"
      }, {
      name      = "GUEST_USER_ADDRESS"
      valueFrom = "/guest/user"
      },{
      name      = "RAILS_MASTER_KEY"
      valueFrom = "/rails/masterkey"
    }]
    systemControls = []
    ulimits        = []
    volumesFrom    = []
  }])
  cpu                      = jsonencode(512)
  execution_role_arn       = "arn:aws:iam::110550326393:role/ecsTaskExecutionRole"
  family                   = "body_record_task"
  ipc_mode                 = null
  memory                   = jsonencode(3072)
  network_mode             = "awsvpc"
  pid_mode                 = null
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = null
  tags                     = {}
  tags_all                 = {}
  task_role_arn            = "arn:aws:iam::110550326393:role/ecsTaskRole"
  track_latest             = false
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_cluster" "body-record-cluster" {
  name     = "body-record2"
  tags     = {}
  tags_all = {}
  configuration {
    execute_command_configuration {
      kms_key_id = null
      logging    = "DEFAULT"
    }
  }
  service_connect_defaults {
    namespace = "arn:aws:servicediscovery:us-east-1:110550326393:namespace/ns-damddspfdzn23kg7"
  }
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_iam_role_policy_attachment" "task-execution-attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = "ecsTaskExecutionRole"
}

resource "aws_iam_role" "task" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Sid = ""
    }]
    Version = "2012-10-17"
  })
  description           = "Allows ECS tasks to call AWS services on your behalf."
  force_detach_policies = false
  managed_policy_arns   = ["arn:aws:iam::aws:policy/AdministratorAccess", "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
  max_session_duration  = 3600
  name                  = "ecsTaskRole"
  name_prefix           = null
  path                  = "/"
  permissions_boundary  = null
  tags                  = {}
  tags_all              = {}
}

resource "aws_iam_role" "task-execution" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Sid = ""
    }]
    Version = "2012-10-17"
  })
  description           = "Allows ECS tasks to call AWS services on your behalf."
  force_detach_policies = false
  managed_policy_arns   = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy", "arn:aws:iam::aws:policy/AmazonSSMFullAccess"]
  max_session_duration  = 3600
  name                  = "ecsTaskExecutionRole"
  name_prefix           = null
  path                  = "/"
  permissions_boundary  = null
  tags                  = {}
  tags_all              = {}
}

resource "aws_ecs_service" "body-record-service" {
  cluster                            = "arn:aws:ecs:us-east-1:110550326393:cluster/body-record2"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 0
  enable_ecs_managed_tags            = true
  enable_execute_command             = false
  force_new_deployment               = null
  health_check_grace_period_seconds  = 0
  iam_role                           = "/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  launch_type                        = null
  name                               = "body-record-service"
  platform_version                   = "1.4.0"
  propagate_tags                     = "NONE"
  scheduling_strategy                = "REPLICA"
  tags                               = {}
  tags_all                           = {}
  task_definition                    = "body_record_task:17"
  triggers                           = {}
  wait_for_steady_state              = null
  alarms {
    alarm_names = []
    enable      = false
    rollback    = false
  }
  capacity_provider_strategy {
    base              = 0
    capacity_provider = "FARGATE"
    weight            = 1
  }
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
  deployment_controller {
    type = "ECS"
  }
  load_balancer {
    container_name   = "body_record"
    container_port   = 3000
    elb_name         = null
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:110550326393:targetgroup/body-record-group/0e079d458796b3c5"
  }
  network_configuration {
    assign_public_ip = true
    security_groups  = ["sg-0f6aa001f35ffcb6a"]
    subnets          = ["subnet-0373469010862d2de", "subnet-0a753077dc7206d99"]
  }
}
