provider "aws" {
	access_key = "YOUR ACCESS KEY"
	secret_key = "YOUR SECRET KEY"
	region = "us-west-2"
}

resource "aws_launch_configuration" "bar" {
	image_id = "ami-06e54d05255faf8f6"
	instance_type = "t2.micro"
    key_name= "aws"

    user_data = <<-EOF
        #! /bin/bash
        mkdir -p bar
        echo "Hello world from bar!" > bar/index.html
        nohup busybox httpd -f -p 80 &
    EOF

    security_groups = [aws_security_group.alb.id]
    lifecycle {
        create_before_destroy = true
    }
}	

resource "aws_launch_configuration" "foo" {
	image_id = "ami-06e54d05255faf8f6"
	instance_type = "t2.micro"
    key_name= "aws"

    user_data = <<-EOF
         #! /bin/bash
        mkdir -p foo
        echo "Hello world from foo!" > foo/index.html
        nohup busybox httpd -f -p 80 &
    EOF

    security_groups = [aws_security_group.alb.id]
    lifecycle {
        create_before_destroy = true
    }
}	

resource "aws_autoscaling_group" "bar" {
    launch_configuration = aws_launch_configuration.bar.name
    
    vpc_zone_identifier = data.aws_subnet_ids.default.ids
    min_size = 1
    max_size = 2

    target_group_arns = [aws_lb_target_group.bar.arn]
    health_check_type = "ELB"
}

resource "aws_autoscaling_group" "foo" {
    launch_configuration = aws_launch_configuration.foo.name
    
    vpc_zone_identifier = data.aws_subnet_ids.default.ids
    min_size = 1
    max_size = 2

    target_group_arns = [aws_lb_target_group.foo.arn]
    health_check_type = "ELB"
}

resource "aws_lb_target_group" "bar" {
    name = "terraform-bar-example"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id
}

resource "aws_lb_target_group" "foo" {
    name = "terraform-foo-example"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id
}

resource "aws_lb_listener_rule" "bar" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100

    condition {
        path_pattern {
            values = ["/bar/*"]
        }
    }

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.bar.arn
    }
}

resource "aws_lb_listener_rule" "foo" {
    listener_arn = aws_lb_listener.http.arn
    priority = 99

    condition {
        path_pattern {
            values = ["/foo/*"]
        }
    }

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.foo.arn
    }
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.example.arn
    port = 80
    protocol = "HTTP"

    default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Page not found!"
      status_code  = "404"
    }
  }
}

resource "aws_lb" "example" {
    name = "terraform-asg-example"
    load_balancer_type = "application"
    subnets = data.aws_subnet_ids.default.ids
    security_groups = [aws_security_group.alb.id]
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnet_ids" "default" {
    vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "alb" { 
    name = "terraform-example-instance" 
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp" 
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
 