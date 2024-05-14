output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value = aws_db_instance.blog_mysql_db.endpoint
}

output "ec2_instance_ip" {
  description = "The public IP address of the EC2 instance"
  value = aws_instance.wordpress_ec2.public_ip
}

output "ec2_instance_az" {
  description = "The availability zone of the EC2 instance"
  value = aws_instance.wordpress_ec2.availability_zone
}

output "efs_id" {
  description = "The ID of the EFS filesystem"
  value = aws_efs_file_system.wordpress_efs.id
}
