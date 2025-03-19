# Terraform 
## What is Terraform 
HashiCorp Terraform is an infrastructure as code tool that lets you define both cloud and on-prem resources in human-readable configuration files that you can version, reuse, and share. You can then use a consistent workflow to provision and manage all of your infrastructure throughout its lifecycle. Terraform can manage low-level components like compute, storage, and networking resources, as well as high-level components like DNS entries and SaaS features.

---
## How does terraform work 
Terraform creates and manages resources on cloud platforms and other services through their application programming interfaces (APIs)
### Key componets: 
* Configuration Files:
You write configuration files (.tf files) that describe the infrastructure you want to create or manage. For example, you can define resources like EC2 instances, VPCs, security groups, and more.
* Providers:
Providers are responsible for interacting with the APIs of different cloud services (e.g., AWS, Google Cloud, Azure). You define which provider you are using in your configuration.
* Resources:
Resources are the components of your infrastructure (e.g., EC2 instance, S3 bucket, RDS database). You declare them in your configuration files.
* State:
Terraform keeps track of the current state of your infrastructure in a state file (terraform.tfstate). This file is used to compare your current infrastructure with the desired configuration

## terraform installation 
```
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```
check avaliable version 
```
terraform --version
``` 
## Basic Workflow
* Write Configuration:
You create .tf files that define your infrastructure. For example, a simple configuration for an AWS EC2 instance:
```
    provider "aws" {
       region = "us-west-2"
    }
  
    resource "aws_instance" "example" {
       ami           = "ami-0c55b159cbfafe1f0"
     instance_type = "t2.micro"
    }
```
* Initialize:
You run terraform init to initialize your working directory. This command installs the necessary provider plugins for the services you're using (e.g., AWS, Azure):
```
    terraform init
```
* Plan:
Terraform will generate an execution plan, which shows what actions it will take to match the desired state. This is done with terraform plan:
```
    terraform plan
```
The plan will show you the infrastructure changes Terraform will make (like creating resources).

* Apply:
Once you re satisfied with the plan, you can apply the changes with terraform apply. This command creates, updates, or deletes resources to align the infrastructure with the configuration.
```
    terraform apply
```
* Inspect State:
Terraform uses a state file to track the resources it manages. This state is updated automatically each time terraform apply is run.

* Modify or Destroy:
If you modify your configuration, you can run terraform plan again to see what changes will occur and then terraform apply to apply them.
If you want to destroy all the resources you’ve created, you can use terraform destroy.
```
terraform destroy
 ```
---
## Variables in terraform
Variables in Terraform allow you to define inputs that can be used to configure resources dynamically. They are essentially placeholders for values that you may want to change without having to modify the core configuration.

* Defining variable 
```
  variable "variable_name" {
      description = "A description of the variable"
      type        = string  # (optional: you can specify the type like string, number, list, etc.)
      default     = "default_value"  # (optional: default value for the variable)
    }
```

## Outputs in Terraform
Outputs in Terraform are used to display useful information about your infrastructure after it has been applied. They provide a way to export certain values so they can be used outside of Terraform, such as in other configurations, scripts, or for logging.

* Defining output
```
  output "instance_id" {
    value = aws_instance.example.id
  }
```
## Terraform modules 
Modules in Terraform are a way to organize and reuse infrastructure code. They allow you to encapsulate a set of resources, variables, outputs, and other configurations into a reusable unit that can be easily shared across different configurations and environments. Modules are a key feature in Terraform for maintaining clean, maintainable, and scalable infrastructure

* Types of modules
  1. Root Module: This is the main configuration directory where you define your resources. It's the starting point of your Terraform project.

  2. Child Modules: These are the reusable modules that can be referenced within your root module or other modules. A module can be in a separate directory or         pulled from a public or private registry.
  
  3. Pre-built Modules: The Terraform Registry offers many pre-built modules for different cloud providers and services. These modules can be used directly or         customized for your needs. 
* Module Structure
  A typical Terraform module is just a folder with .tf files. The structure might look like this:
```
  root
 ├── main.tf            # Main configuration
 ├── variables.tf       # Variable definitions
 ├── outputs.tf         # Outputs
 └── README.md          # Documentation (optional)
```
* Using a Module Locally
Create the Module Folder:
For example, you could create a folder named ec2_instance/ with the necessary .tf files.

* Call the Module: In your main configuration:
```
module "ec2_instance" {
  source = "./ec2_instance"   # Local path to the module
  instance_type = "t2.micro"
  ami_id        = "ami-0abcdef1234567890"
}
```
