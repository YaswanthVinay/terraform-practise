To connect three VPCs (VPC A, VPC B, and VPC C) via peering connections and ensure that an EC2 instance in each VPC can communicate with instances in the other VPCs, you need to set up multiple VPC peering connections and configure routing correctly. Here's how you can achieve this step by step:

### Step-by-Step Guide

#### 1. Create VPCs and EC2 Instances
First, create three VPCs and launch an EC2 instance in each VPC.

##### VPC and EC2 Creation (Terraform Configuration)
```hcl
provider "aws" {
  region = "us-west-2"
}

# VPC A
resource "aws_vpc" "vpc_a" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.vpc_a.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_instance" "instance_a" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_a.id
}

# VPC B
resource "aws_vpc" "vpc_b" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.vpc_b.id
  cidr_block = "10.1.1.0/24"
}

resource "aws_instance" "instance_b" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_b.id
}

# VPC C
resource "aws_vpc" "vpc_c" {
  cidr_block = "10.2.0.0/16"
}

resource "aws_subnet" "subnet_c" {
  vpc_id     = aws_vpc.vpc_c.id
  cidr_block = "10.2.1.0/24"
}

resource "aws_instance" "instance_c" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_c.id
}
```

#### 2. Create VPC Peering Connections
Create peering connections between VPC A and VPC B, VPC A and VPC C, and VPC B and VPC C.

##### VPC Peering (Terraform Configuration)
```hcl
# Peering between VPC A and VPC B
resource "aws_vpc_peering_connection" "peer_a_b" {
  vpc_id        = aws_vpc.vpc_a.id
  peer_vpc_id   = aws_vpc.vpc_b.id
  peer_region   = "us-west-2"
  auto_accept   = true
}

# Peering between VPC A and VPC C
resource "aws_vpc_peering_connection" "peer_a_c" {
  vpc_id        = aws_vpc.vpc_a.id
  peer_vpc_id   = aws_vpc.vpc_c.id
  peer_region   = "us-west-2"
  auto_accept   = true
}

# Peering between VPC B and VPC C
resource "aws_vpc_peering_connection" "peer_b_c" {
  vpc_id        = aws_vpc.vpc_b.id
  peer_vpc_id   = aws_vpc.vpc_c.id
  peer_region   = "us-west-2"
  auto_accept   = true
}
```

#### 3. Update Route Tables
Update the route tables of each VPC to ensure that traffic can route between the peered VPCs.

##### Route Tables (Terraform Configuration)
```hcl
# Route for VPC A
resource "aws_route" "route_a_b" {
  route_table_id            = aws_vpc.vpc_a.main_route_table_id
  destination_cidr_block    = aws_vpc.vpc_b.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_a_b.id
}

resource "aws_route" "route_a_c" {
  route_table_id            = aws_vpc.vpc_a.main_route_table_id
  destination_cidr_block    = aws_vpc.vpc_c.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_a_c.id
}

# Route for VPC B
resource "aws_route" "route_b_a" {
  route_table_id            = aws_vpc.vpc_b.main_route_table_id
  destination_cidr_block    = aws_vpc.vpc_a.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_a_b.id
}

resource "aws_route" "route_b_c" {
  route_table_id            = aws_vpc.vpc_b.main_route_table_id
  destination_cidr_block    = aws_vpc.vpc_c.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_b_c.id
}

# Route for VPC C
resource "aws_route" "route_c_a" {
  route_table_id            = aws_vpc.vpc_c.main_route_table_id
  destination_cidr_block    = aws_vpc.vpc_a.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_a_c.id
}

resource "aws_route" "route_c_b" {
  route_table_id            = aws_vpc.vpc_c.main_route_table_id
  destination_cidr_block    = aws_vpc.vpc_b.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_b_c.id
}
```

#### 4. Security Group Configuration
Ensure the security groups of the EC2 instances allow traffic from the other VPCs.

##### Security Groups (Terraform Configuration)
```hcl
# Security Group for instance A
resource "aws_security_group" "sg_a" {
  vpc_id = aws_vpc.vpc_a.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_b.cidr_block, aws_vpc.vpc_c.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for instance B
resource "aws_security_group" "sg_b" {
  vpc_id = aws_vpc.vpc_b.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_a.cidr_block, aws_vpc.vpc_c.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for instance C
resource "aws_security_group" "sg_c" {
  vpc_id = aws_vpc.vpc_c.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_a.cidr_block, aws_vpc.vpc_b.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Assign security groups to instances
resource "aws_instance" "instance_a" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_a.id
  security_groups = [aws_security_group.sg_a.name]
}

resource "aws_instance" "instance_b" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_b.id
  security_groups = [aws_security_group.sg_b.name]
}

resource "aws_instance" "instance_c" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_c.id
  security_groups = [aws_security_group.sg_c.name]
}
```

### Verification
After applying the above Terraform configuration, you can SSH into one EC2 instance and attempt to connect to the other instances using their private IP addresses to verify the connectivity. For example, from EC2 instance A, you should be able to SSH to the private IP addresses of EC2 instances B and C if the security group rules and routes are configured correctly.

### Apply the Configuration
To apply this configuration, save it to a `.tf` file and run the following Terraform commands:
```sh
terraform init
terraform apply
```

This setup ensures that the EC2 instances in each VPC can communicate with each other via the VPC peering connections and the configured routing.
