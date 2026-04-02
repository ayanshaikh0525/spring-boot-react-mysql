resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    
    # Replace later with EKS SG (best practice)
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_subnet_group" "this" {
  name       = "rds-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = var.tags
}

resource "aws_db_instance" "this" {
  identifier = var.identifier

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = var.instance_class

  allocated_storage = var.allocated_storage

  db_name  = var.db_name
  username = var.username
  password = var.password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  multi_az = var.multi_az

  publicly_accessible = false

  skip_final_snapshot = true

  tags = var.tags
}