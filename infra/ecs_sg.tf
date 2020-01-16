resource "aws_security_group" "alb_sg" {
  name     = "${var.ecs_cluster_name}-alb"
  vpc_id   = aws_vpc.primary.id
  ingress {
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port  = 443
    to_port    = 443
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_sg" {
  name     = "${var.ecs_cluster_name}-ecs"
  vpc_id   = aws_vpc.primary.id
  ingress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    security_groups = [aws_security_group.alb_sg.id]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
