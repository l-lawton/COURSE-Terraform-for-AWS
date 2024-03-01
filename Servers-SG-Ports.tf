resource "aws_instance" "db" { //first string tells aws what the resource is. 2nd string tells aws the callable name
    ami = "ami-032598fcc7e9d1c7a" //provides essential info to run an instance
    instance_type = "t2.micro" //general purpose and cheap instance
    
    tags { //tags give more definition
        Name = "DB Server" //this name is what the output screen will show
    }
}

resource "aws_instance" "web" {
    ami = "ami-032598fcc7e9d1c7a"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.web_traffic.Name] //setting what security group i want
    tags {
        Name = "Web Server"
    }
}

resource "aws_eip" "web_ip" {
    instance = aws_instance.web.id //assigns fixed public ip to web
}

variable "ingress" { //ports that can connect
    type = list(number)
    default = [80, 443] //http and https
}

variable "egress" { //connections leave through these ports
    type = list(number)
    default = [80, 443]
}

resource "aws_security_group" "web_traffic" {
    Name = "Allow Web Traffic"

    dynamic "ingress" {
        iterator = port
        for_each = var.ingress
        content {
            from_port = port.value
            to_port = port.value
            protocol = "TCP" //reliable, common security protocol to establish what enters and leaves
            cidr_blocks = ["0.0.0.0/0"] //allows all IPs to enter through selected ports
        }
    }
}

dynamic "egress" {
    iterator = port
    for_each = var.egress
    content {
        from_port = port.value
        to_port = port.value
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"] //allows all IPs to leave through selected ports
    }
}

output "PrivateIP" {
    value = aws_instance.db.private_ip //outputs the database private ip
}

output "PublicIP" {
    value = aws_eip.web_ip.public_ip //outputs the fixed public ip of the web server
}
