terraform {
  backend "remote" {
    organization = "the-nick-org"

    workspaces {
      name = "ci-cd-pipeline-ansible-jenkins-tf"
    }
  }
}