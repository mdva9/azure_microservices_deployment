# Microservices Deployment on Microsoft Azure

This project demonstrates how to deploy two microservices (Spring Boot & Flask) on Microsoft Azure using **Docker**, **Terraform**, and **GitLab CI/CD**.

---

## Project Structure


```
azure_microservices_deployment/
├── service-java/
│   └── service-java-main/
│       ├── Dockerfile
│       ├── src/
│       ├── pom.xml
│       └── ...
├── service-python/
│   └── service-python-main/
│       ├── Dockerfile
│       ├── app.py
│       ├── requirements.txt
│       ├── test_app.py
│       └── ...
├── terraform/
│   ├── main.tf
│   ├── provider.tf
│   ├── outputs.tf
│   ├── variables.tf
│   └── .terraform.lock.hcl
├── .gitignore
├── .gitlab-ci.yml
└── docker-compose.yml

```

## Docker Image Commands

### Spring Boot Service
```bash
cd service-java/service-java-main
docker build -t service-java .
```

### Flask Service

```bash
# Navigate to the Python service directory
cd service-python/service-python-main

# Build the Docker image
docker build -t service-python .
```

## Running the Containers

### Individually


Spring Boot Service:

```bash
# Run Spring Boot image 
docker run -p 8080:8080 service-java
```

Flask Service :
```bash
# Run Flask image
docker run -p 5000:5000 service-python
```

### With Docker Compose

```bash
# Navigate to the project root (where the docker-compose.yml is located)
cd 58493

# Start the services defined in docker-compose.yml
docker-compose up -d

# List running containers
docker-compose ps

# Start a specific service
docker-compose start "name-service"

# Stop a specific service
docker-compose stop "name-service"

# Stop and remove all services
docker-compose down

```

## Verifying Functionality

To test that the services are working correctly:

```bash
# Test Flask service
curl http://localhost:5000/api/message

# Spring Boot proxy (calling Flask)
curl http://localhost:8080/proxy

```

## Technical Specifications

### Spring Boot Service
- Port: 8080
- Env variable: FLASK_URL

### Service Flask
- Port: 5000


## GitLab Runner Setup

Create config folder :
```bash
# The folder must be created at the root of the project.
mkdir path_to/gitlab-runner/config/ 
```


Install runner with Docker:
```bash
# Run the Spring Boot image
docker run -d --name gitlab-runner --restart always \
-v /path_to/gitlab-runner/config:/etc/gitlab-runner \
-v /var/run/docker.sock:/var/run/docker.sock \
gitlab/gitlab-runner:latest
```


Création d'un token pour le projet:

    - Go to Settings > CI/CD.
    - Open Runners section.
    - Click New project runner.
    - Enable Run untagged jobs.
    - Copy the authentication token.


Register runner:

```bash
# Replace the variable with the token 
docker run --rm -v /path_to/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register \
--non-interactive \
--url "https://git.esi-bru.be" \
--token "$RUNNER_TOKEN" \
--executor "docker" \
--docker-image alpine:latest \
--description "docker-runner"

```

## Provisioning Azure Infrastructure with Terraform

Login to Azure
```bash
az login
```
Retrieve subscription_id and tenant_id


Create service principal:

```bash
az ad sp create-for-rbac --name <service_principal_name> --role Contributor --scopes /subscriptions/<subscription_id>
```
Once the service has been created, retrieve the app_id and password.

Export credentials :

```bash
# Enables connection to Microsoft Azure via a Core Service
ARM_CLIENT_ID="app_id"
ARM_CLIENT_SECRET="password"
ARM_SUBSCRIPTION_ID="subscription_id"
ARM_TENANT_ID="tenant_id"
```

Assign role:
```bash
az role assignment create --assignee ${ARM_CLIENT_ID} --role "Owner" --scope /subscriptions/${ARM_SUBSCRIPTION_ID}
```

Terraform commands :

These commands should only be executed when all files are defined.

```bash
# Initialize a Terraform working directory
terraform init
```

```bash
# Validate that the configuration is syntactically correct
terraform validate 
```
```bash
# Preview the changes that will be applied 
# (useful if the directory was already initialized and you want to see differences)
terraform plan
```

```bash
# Apply the configuration and create/modify the infrastructure
terraform apply
```

Deploying Images to Azure Container Registry (ACR) :

Create registry:

```bash
az acr create --resource-group MyResourceGroup --name myacrregistry58493 --sku Basic --admin-enabled true
```

Login:

```bash
az acr login myacrregistry
```
Build and push :

Spring Boot Service:
```bash
# Go to the java service directory
cd java-service/java-service-main

# Build the Docker image and push the image
docker build -t myacrregistry.azurecr.io/java-service:latest .
docker push myacrregistry.azurecr.io/java-service:latest
```

Flask Service :
```bash
# Go to the python service directory
cd service-python/service-python-main

# Build the Docker image and push the image 
docker build -t myacrregistry.azurecr.io/service-python:latest .
docker push myacrregistry.azurecr.io/service-python:latest
```

# GitLab Runner with Docker-in-Docker

Define variables in GitLab:

    - REGISTRY_PASSWORD.
    - USERNAME.
    - REGISTRY_PASSWORD.


Configuring GitLab Runner with a new volume:

Remove GitLab Runner from the project's list of runners.

Stop the GitLab Runner container with the command: docker stop gitlab-runner.

Create a new GitLab Runner container:
Delete the GitLab Runner container with: docker rm gitlab-runner.

Commandes bash :

```bash
# Recreate runner:
docker run -d ^
  --name gitlab-runner ^
  --restart always ^
  -v /path_to/gitlab-runner/config:/etc/gitlab-runner ^
  -v /var/run/docker.sock:/var/run/docker.sock ^
  gitlab/gitlab-runner:latest


# Register runner with volumes:
docker run --rm ^
  -v /path_to/gitlab-runner/config:/etc/gitlab-runner ^
  gitlab/gitlab-runner register ^
    --non-interactive ^
    --url "https://git.esi-bru.be" ^
    --token "$RUNNER_TOKEN" 
    --executor "docker" ^
    --docker-image alpine:latest ^
    --description "docker-runner"
    --docker-volumes /var/run/docker.sock:/var/run/docker.sock
```
