aws_region = "us-east-1"
profile = "default"

existing_vpc_name = "my-k8s-vpc"

# Nodes
node = {
  ami_id                   = "ami-0c02fb55956c7d316"
  key_name                 = "k8s-key-us-east-1"
  instance_type_master     = "t2.medium"
  instance_type_worker     = "t2.medium"
  allowed_ip               = "203.0.113.10/32"
  sg_name                  = "k8s-sg"
  sg_description           = "Allow K8s and SSH"
  inbound_ports            = [6443, 10250, 30000, 32767]
  egress_cidr_block        = "0.0.0.0/0"
  master_node_name         = "k8s-master-node"
  master_node_role         = "master"
  master_node_cluster      = "dev-cluster"
  ingress_cidr_block       = "10.0.0.0/16"
  worker_node_cluster      = "dev-cluster"
  worker_node_role         = "worker"
  worker_node_name         = "k8s-worker"
  document_type            = "Command"
  network_bastion_sg       = "sg-0429e6303d7720ace"     #change the sg and add the bastion sg of network
}

# IAM
iam = {
  manager_role_name        = "manager-ssm-role"
  node_role_name           = "node-ssm-role"
  manager_profile_name     = "manager-ssm-profile"
  node_profile_name        = "node-ssm-profile"
}

# manager Host
manager = {
  ami_id                = "ami-0c02fb55956c7d316"
  manager_name          = "nodes-manager"
  manager_role          = "manager"
  manager_cluster       = "dev-cluster"
  manager_sg_name       = "nodes-manager-sg"
  manager_instance_type = "t2.micro"
  user_data_file        = "./user_data_ssm.sh"
  subnet_index          = 3
  network_bastion_sg    = "sg-0429e6303d7720ace"        #change the sg and add the bastion sg of network
}


