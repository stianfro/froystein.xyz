terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

data "digitalocean_project" "k8s_lab" {
  name = "k8s_lab"
}

data "digitalocean_kubernetes_versions" "auto" {
  version_prefix = "1.21."
}

resource "digitalocean_kubernetes_cluster" "froystein-k8s-1" {
  name         = "froystein-k8s-1"
  region       = "fra1"
  version      = data.digitalocean_kubernetes_versions.auto.latest_version
  auto_upgrade = true

  maintenance_policy {
    start_time  = "04:00"
    day         = "sunday"
  }

  node_pool {
    name   = "default"
    size   = "s-1vcpu-2gb"
    node_count = 1
  }
}

resource "digitalocean_project_resources" "k8s" {
  project = data.digitalocean_project.k8s_lab.id
  resources = [
    digitalocean_kubernetes_cluster.froystein-k8s-1.urn
  ]
}