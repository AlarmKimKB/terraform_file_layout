resource "aws_db_subnet_group" "scott_db_subnet" {
  name       = "scott_db_subnet_group"
  subnet_ids = [aws_subnet.scott_subnet3.id, aws_subnet.scott_subnet4.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "scott_rds" {
  identifier_prefix      = "terraform"
  engine                 = "mysql"
  allocated_storage      = 10
  instance_class         = "db.t2.micro"
  db_subnet_group_name   = aws_db_subnet_group.scott_db_subnet.name
  vpc_security_group_ids = [aws_security_group.scott_sg2.id]
  skip_final_snapshot    = true

  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
}
