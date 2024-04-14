provider "aws" {
    region = "ap-southeast-1"
}

resource "aws_instance" "dpp-aws" {
    ami = "ami-08e4b984abde34a4f"                             //ubuntu AMI.
    key_name = "Youtubeproject"
    instance_type = "t2.medium"
    vpc_security_group_ids = [aws_security_group.dpp-sec.id]
    subnet_id = aws_subnet.dpp-public-subnet-01.id
    for_each = toset (["Jenkins-master", "Build-slave", "Ansible"])     //It create 3 instances.
    tags = {
        Name = "${each.key}"                                       //It will give the Different names as mentioned in the for_each.
    }

    root_block_device {
        volume_size = 20  // Specify the size of the root volume in GB
    }
}

resource "aws_security_group" "dpp-sec" {
    name = "dpp-sec"
    description = "This is my security group"
    vpc_id = aws_vpc.dpp-vpc.id

    // SSH access
    ingress {
        description = "SSH access"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // Port 30,000 to 32,767: Used for deploying applications when using virtual machines as a Kubernetes cluster.
    ingress {
        description = "Deploying applications using virtual machines as Kubernetes cluster"
        from_port = 30000
        to_port = 32767
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // Port 465: Used for sending mail notifications from Jenkins pipeline to Gmail addresses.
    ingress {
        description = "Sending mail notifications from Jenkins pipeline to Gmail addresses"
        from_port = 465
        to_port = 465
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // Port 6443: Required during the setup of the Kubernetes cluster.
    ingress {
        description = "Setup of the Kubernetes cluster"
        from_port = 6443
        to_port = 6443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // Ports 443 (HTTPS) and 80 (HTTP): Used for web traffic.
    ingress {
        description = "Web traffic"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "Web traffic"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // Ports 3000 to 10000: Range for deploying applications.
    ingress {
        description = "Range for deploying applications"
        from_port = 3000
        to_port = 10000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // Port 25 (SMTP)
    ingress {
        description = "SMTP"
        from_port = 25
        to_port = 25
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "dpp-sec"
    }
}

resource "aws_vpc" "dpp-vpc" {
    cidr_block = "10.1.0.0/16"
    tags = {
        Name = "dpp-vpc"
    }
}

resource "aws_subnet" "dpp-public-subnet-01" {
    vpc_id = aws_vpc.dpp-vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "dpp-public-subnet-01"
    }
}

resource "aws_subnet" "dpp-public-subnet-02" {
    vpc_id = aws_vpc.dpp-vpc.id
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-southeast-1b"
    tags = {
        Name = "dpp-public-subnet-02"
    }
}

resource "aws_internet_gateway" "dpp-igw" {
    vpc_id = aws_vpc.dpp-vpc.id
    tags = {
        Name = "dpp-igw"
    }
}

resource "aws_route_table" "dpp-rt" {
    vpc_id = aws_vpc.dpp-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dpp-igw.id
    }
}

resource "aws_route_table_association" "dpp-rta-public-subnet-01" {
    subnet_id = aws_subnet.dpp-public-subnet-01.id
    route_table_id = aws_route_table.dpp-rt.id
}

resource "aws_route_table_association" "dpp-rta-public-subnet-02" {
    subnet_id = aws_subnet.dpp-public-subnet-02.id
    route_table_id = aws_route_table.dpp-rt.id
}
