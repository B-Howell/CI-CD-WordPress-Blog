terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0, < 5.0"
    }
  }
  backend "s3" {
    bucket  = "bhcrc-tfstate"
    key     = "blog.tfstate"
    region  = "us-east-1"
    profile = "terraform"

  }
}

provider "aws" {
  region  = "us-east-1"
}

# Pull in my websites hosted zone so we can create a new record for it

data "aws_route53_zone" "hosted_zone" {
  name         = "brettmhowell.com."
  private_zone = false
}

module "vpc_module" {
  source = "./vpc-module"

  vpc_cidr              = "10.16.2.0/23"
  vpc_name              = "Blog"
  public_subnet_1_cidr  = "10.16.2.0/27"
  public_subnet_2_cidr  = "10.16.2.32/27"
  private_subnet_1_cidr = "10.16.2.64/27"
  private_subnet_2_cidr = "10.16.2.96/27"
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.vpc_module.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"
  description = "Security group for WordPress EC2 instance"
  vpc_id      = module.vpc_module.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "efs-sg"
  description = "Security group for EFS"
  vpc_id      = module.vpc_module.vpc_id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_sg.id]
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Security group for DB"
  vpc_id      = module.vpc_module.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#------------------------------- MySQL DB ---------------------------------#

resource "aws_db_instance" "blog_mysql_db" {
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  identifier             = "blog"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql5.7"
  publicly_accessible    = false
  skip_final_snapshot    = true
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "blog"
  subnet_ids = [module.vpc_module.private_subnet_2_id, module.vpc_module.private_subnet_1_id]

  tags = {
    Name = "Blog DB subnet group"
  }
}

#----------------------------- EFS ----------------------------------------#

resource "aws_efs_file_system" "wordpress_efs" {
  creation_token = "wordpress-efs"

  tags = {
    Name = "WordPressEFS"
  }
}

resource "aws_efs_mount_target" "efs_mt" {
  file_system_id  = aws_efs_file_system.wordpress_efs.id
  subnet_id       = module.vpc_module.private_subnet_1_id
  security_groups = [aws_security_group.efs_sg.id]
}

#----------------- Application Load Balancer -------------------------------#

resource "aws_lb" "blog_alb" {
  name               = "blog-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [module.vpc_module.public_subnet_1_id, module.vpc_module.public_subnet_2_id]

  enable_deletion_protection = false

  tags = {
    Name = "blogALB"
  }
}

resource "aws_lb_target_group" "blog_tg" {
  name     = "blog-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc_module.vpc_id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
  }

  tags = {
    Name = "blogTG"
  }
}

resource "aws_lb_target_group_attachment" "blog_tg_attachment" {
  target_group_arn = aws_lb_target_group.blog_tg.arn
  target_id        = aws_instance.wordpress_ec2.id
  port             = 80
}

resource "aws_lb_listener" "blog_listener_http" {
  load_balancer_arn = aws_lb.blog_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blog_tg.arn
  }
}

resource "aws_lb_listener" "blog_listener_https" {
  load_balancer_arn = aws_lb.blog_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.blog_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blog_tg.arn
  }
}


#---------------------------- EC2 ------------------------------------------#

resource "aws_instance" "wordpress_ec2" {
  ami                         = "ami-0fa1ca9559f1892ec"
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc_module.public_subnet_1_id
  security_groups             = [aws_security_group.wordpress_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = "EC2-Access-EFS-CWLogs-SSM"
  key_name                    = aws_key_pair.ec2_keypair.key_name

  tags = {
    Name = "WordPressEC2"
  }
}

resource "aws_key_pair" "ec2_keypair" {
  key_name   = "mykey"
  public_key = file("${path.module}/ssh-pub/mykey.pub")
}

#------------------------ CloudWatch Logs ----------------------------------#

resource "aws_cloudwatch_log_group" "wordpress_log_group" {
  name              = "/aws/ec2/wordpress"
  retention_in_days = 30
}

#-------------------------- Route 53 ---------------------------------------#

resource "aws_route53_record" "a_record" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "wp-blog.brettmhowell.com"
  type    = "A"

  alias {
    name                   = aws_lb.blog_alb.dns_name
    zone_id                = aws_lb.blog_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "blog_cert" {
  domain_name       = "wp-blog.brettmhowell.com"
  validation_method = "DNS"
}
