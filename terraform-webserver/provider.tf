terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

# Specify the GCP Provider
provider "google" {
  credentials = file("./poised-honor-322203-28442ddeabbc.json")
  project     = var.project_id
  region      = var.region
}

