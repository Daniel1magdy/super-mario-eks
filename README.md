🎮 Super Mario App CI/CD on AWS with Terraform, Jenkins, EKS
This project demonstrates a complete DevOps pipeline to deploy a containerized Super Mario game application on AWS using Terraform, EKS, Jenkins, GitHub, S3, and DynamoDB — all configured using Infrastructure as Code (IaC) and built within the AWS Free Tier where possible.

🧰 Tools & Technologies Used
Tool	Purpose
Terraform	Provision AWS infrastructure (EKS cluster, VPC, IAM, S3, DynamoDB, etc.)
AWS EKS	Kubernetes cluster to run and manage Dockerized app
Jenkins	CI/CD server to automate provisioning and deployment
GitHub	Source code repository and Jenkins pipeline trigger
Docker	Containerization of the Super Mario app
kubectl	Kubernetes CLI tool to manage deployments
AWS S3	Stores Terraform state file for collaboration and persistence
DynamoDB	Locks Terraform state to prevent concurrent updates
ALB (Load Balancer)	Automatically provisioned by EKS service of type LoadBalancer for public app access
IAM Roles	Secure access between Jenkins, EKS, and EC2

🏗️ Architecture Overview
java
Copy
Edit
GitHub Repo ───> Jenkins EC2 ───> Terraform ───> AWS Infrastructure:
                                            └──> VPC
                                            └──> EKS Cluster
                                            └──> Node Group (EC2)
                                            └──> S3 (state storage)
                                            └──> DynamoDB (state locking)
                                            └──> Super Mario App (Docker)
                                                 └──> LoadBalancer
📦 Project Structure
python
Copy
Edit
super-mario-eks/
├── .github/              # (Optional GitHub Actions, if any)
├── kubernetes/
│   ├── deployment.yaml   # Defines app deployment to EKS
│   └── service.yaml      # Exposes app via LoadBalancer
├── terraform/
│   ├── main.tf           # Main infra logic (EKS, IAM, etc.)
│   ├── variables.tf      # Input variables
│   └── backend.tf        # S3 + DynamoDB configuration
├── Jenkinsfile           # CI/CD pipeline definition
├── README.md             # Project documentation
🚀 CI/CD Pipeline Flow (Defined in Jenkinsfile)
Init Terraform

Jenkins initializes Terraform in the terraform/ directory

Uses aws-creds from Jenkins credentials store

Provision Infrastructure

Terraform provisions:

EKS Cluster

Node Group (EC2 instances)

IAM roles

VPC/Subnets/Security Groups

S3 backend for state file

DynamoDB for locking

Configure kubectl

Jenkins sets up kubectl using aws eks update-kubeconfig

Deploy App to Kubernetes

Jenkins applies:

kubernetes/deployment.yaml → Deploys Dockerized Super Mario

kubernetes/service.yaml → Creates a LoadBalancer

Get LoadBalancer URL

The app becomes accessible via the AWS-generated public LoadBalancer DNS.

🌐 Accessing the Super Mario App
Once deployed, run:

bash
Copy
Edit
kubectl get svc super-mario-service
Look for the EXTERNAL-IP (LoadBalancer URL) and open it in your browser:

arduino
Copy
Edit
http://a1234567890abcdef.elb.eu-west-2.amazonaws.com
💾 Terraform State Management
To avoid conflicts and ensure collaboration safety:

Resource	Purpose
S3 Bucket	Stores .tfstate file (current infra)
DynamoDB	Locks the state file during operations

Defined in terraform/backend.tf.

💸 Cost Optimization
Default EKS node uses t2.micro instance (Free Tier eligible).

Only 1 node by default.

All AWS services are in eu-west-2 (London) region.

LoadBalancer (ELB) is chargeable — destroy infra when not in use.

⚠️ Stopping Chargeable Resources
To avoid charges:

bash
Copy
Edit
cd terraform
terraform destroy -auto-approve
🔁 Rebuilding From Scratch
To rebuild everything:

bash
Copy
Edit
git clone https://github.com/your-username/super-mario-eks.git
cd super-mario-eks
# Run Jenkins Pipeline or manually:
cd terraform
terraform init
terraform apply -auto-approve
📈 Auto Scaling Support
To enable Auto Scaling:

Modify EKS node group in main.tf:

hcl
Copy
Edit
desired_size = 1
min_size     = 1
max_size     = 3
Or scale manually using:

bash
Copy
Edit
aws eks update-nodegroup-config --cluster-name super-mario-eks \
  --nodegroup-name free_tier_nodes --scaling-config desiredSize=2,maxSize=3,minSize=1
✅ Final Outcome
Jenkins automates end-to-end provisioning and deployment.

Your app is live on the internet behind a secure LoadBalancer.

Code, infrastructure, and deployment are fully automated and repeatable.
