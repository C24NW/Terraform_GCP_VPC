#Create google provider
provider "google" {
  project     = "terraformproject-391421"
  credentials = file("credentials.json")
  region      = "us-central1"
  zone        = "us-central1-c"
}

#Create VPC
resource "google_compute_network" "vpc1" {
  name                    = "vpc1"
  auto_create_subnetworks = false
}

#Create subnet 1
resource "google_compute_subnetwork" "subnet1" {
  name          = "subnet1"
  ip_cidr_range = "10.1.0.0/16"
  network       = google_compute_network.vpc1.id
}

#Create subnet 2
resource "google_compute_subnetwork" "subnet2" {
  name          = "subnet2"
  ip_cidr_range = "10.2.0.0/16"
  network       = google_compute_network.vpc1.id
}

#Create compute instance 1
resource "google_compute_instance" "vm1" {
  name                      = "vm1"
  machine_type              = "f1-micro"
  zone                      = "us-central1-a"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network    = google_compute_network.vpc1.id
    subnetwork = google_compute_subnetwork.subnet1.id
    access_config {
    }
  }
}

#Create compute instance 2
resource "google_compute_instance" "vm2" {
  name                      = "vm2"
  machine_type              = "f1-micro"
  zone                      = "us-central1-a"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network    = google_compute_network.vpc1.id
    subnetwork = google_compute_subnetwork.subnet2.id
    access_config {
    }
  }
}
