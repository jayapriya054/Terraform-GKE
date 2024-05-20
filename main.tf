terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0" // Specify the version range you want to use
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.13.1" // Specify the version range you want to use
    }
  }
}

provider "google" {
  project = "engaged-arcanum-419822"
  // Configuration options for the Google provider
}

provider "kubernetes" {
  config_path    = "~/.kube/config"  # Path to your kubeconfig file
  version        = "~> 2.0"          # Specify the version range you want to use
}



resource "google_container_cluster" "mycluster" {
  name     = "my-gke-cluster"
  location = "us-central1"
  remove_default_node_pool = true
  initial_node_count       = 3
  

}

resource "google_container_node_pool" "my_nodes" {       
  name       = "my-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.mycluster.name
  node_count = 3

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

  }


}

resource "kubernetes_namespace" "preview" {           
  metadata {
    annotations = {
      name = "preview"
    }

    labels = {
      mylabel = "preview"
    }

    name = "preview"
  }
}
resource "kubernetes_namespace" "staging" {
  metadata {
    annotations = {
      name = "staging"
    }

    labels = {
      mylabel = "staging"
    }

    name = "staging"
  }
}

resource "kubernetes_namespace" "production" {
  metadata {
    annotations = {
      name = "production"
    }

    labels = {
      mylabel = "production"
    }

    name = "production"
  }
}

module "preview_deployment_frontend" {
  source = "./modules/app/deployments"
  
  name = "frontendapp"
  namespace = "preview"
  myapp = "frontendapp"
  environment = "preview"
  replica = 1
  image = "jayapriya054/demo-frontend:latest"
  port = 80
  # Add additional parameters as needed
}
module "preview_deployment_backend1" {
  source = "./modules/app/deployments"
 
  name = "backend1app"
  namespace = "preview"
  myapp = "backend1app"
  environment = "preview"
  replica = 1
  image = "jayapriya054/demo-backend1:latest"
  port = 8080
  # Add additional parameters as needed
}
module "preview_deployment_backend2" {
  source = "./modules/app/deployments"
  
  name = "backend2app"
  namespace = "preview"
  myapp = "backend2app"
  environment = "preview"
  replica = 1
  image = "jayapriya054/demo-backend2:latest"
  port = 5000
  # Add additional parameters as needed
}

module "staging_frontend_deployments" {
  source = "./modules/app/deployments"
  
  name = "frontendapp"
  namespace = "staging"
  myapp = "frontendapp"
  environment = "staging"
  replica = 3
  image = "jayapriya054/demo-frontend:latest"
  port = 80
  # Add additional parameters as needed
}
module "staging_backend1_deployments" {
  source = "./modules/app/deployments"
  
  name = "backend1app"
  namespace = "staging"
  myapp = "backend1app"
  environment = "staging"
  replica = 3
  image = "jayapriya054/demo-backend1:latest"
  port = 8080
  # Add additional parameters as needed
}
module "staging_backend2_deployments" {
  source = "./modules/app/deployments"
  
  name = "backend2app"
  namespace = "staging"
  myapp = "backend2app"
  environment = "staging"
  replica = 3
  image = "jayapriya054/demo-backend2:latest"
  port = 5000
  # Add additional parameters as needed
}
module "production_frontend_deployments" {
  source = "./modules/app/deployments"
  
  name = "frontendapp"
  namespace = "production"
  myapp = "frontendapp"
  environment = "production"
  replica = 3
  image = "jayapriya054/demo-frontend:latest"
  port = 80
  # Add additional parameters as needed
}
module "production_backend1_deployments" {
  source = "./modules/app/deployments"
  
  name = "backend1app"
  namespace = "production"
  myapp = "backend1app"
  environment = "production"
  replica = 3
  image = "jayapriya054/demo-backend1:latest"
  port = 8080
  # Add additional parameters as needed
}
module "production_backend2_deployments" {
  source = "./modules/app/deployments"
  
  name = "backend2app"
  namespace = "production"
  myapp = "backend2app"
  environment = "production"
  replica = 3
  image = "jayapriya054/demo-backend2:latest"
  port = 5000
  # Add additional parameters as needed
}
module "preview_frontend_service" {
  source = "./modules/app/service"
  
  namespace = "preview"
  app = "frontendser"
  myapp = "frontendapp"
  lb = "LoadBalancer"
  port = 80
  targetPort = 80
  # Add additional parameters as needed
}
module "preview_backend1_service" {
  source = "./modules/app/service"
  
  namespace = "preview"
  app = "backend1ser"
  myapp = "backend1app"
  lb = "LoadBalancer"
  port = 80
  targetPort = 8080
}
module "preview_backend2_service" {
  source = "./modules/app/service"
  lb = "ClusterIP"
  namespace = "preview"
  app = "backend2ser"
  myapp = "backend2app"
  port = 80
  targetPort = 5000
  # Add additional parameters as needed
}

module "staging_frontend_service" {
  source = "./modules/app/service"
  
  namespace = "staging"
  app = "frontendser"
  myapp = "frontendapp"
  lb = "LoadBalancer"
  port = 80
  targetPort = 80
  # Add additional parameters as needed
}
module "staging_backend1_service" {
  source = "./modules/app/service"
  
  namespace = "staging"
  app = "backend1ser"
  myapp = "backend1app"
  lb = "LoadBalancer"
  port = 80
  targetPort = 8080
  # Add additional parameters as needed
}
module "staging_backend2_service" {
  source = "./modules/app/service"
  
  namespace = "staging"
  app = "backend2ser"
  myapp = "backend2app"
  lb = "ClusterIP"
  port = 80
  targetPort = 5000
  # Add additional parameters as needed
}

module "production_frontend_service" {
  source = "./modules/app/service"
  
  namespace = "production"
  app = "frontendser"
  myapp = "frontendapp"
  lb = "LoadBalancer"
  port = 80
  targetPort = 80
  # Add additional parameters as needed
}

module "production_backend1_service" {
  source = "./modules/app/service"
  
  namespace = "production"
  app = "backend1ser"
  myapp = "backend1app"
  lb = "LoadBalancer"
  port = 80
  targetPort = 8080
  # Add additional parameters as needed
}
module "production_backend2_service" {
  source = "./modules/app/service"
  
  namespace = "production"
  app = "backend2ser"
  myapp = "backend2app"
  lb = "ClusterIP"
  port = 80
  targetPort = 5000
  # Add additional parameters as needed
}
