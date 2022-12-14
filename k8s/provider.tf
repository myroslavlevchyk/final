provider "google" {
  credentials = "~/final_task/mygcp-creds1.json"  
  project     = "${var.project_id}"
  zone   = "us-central1-a"
}
