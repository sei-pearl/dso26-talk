# Tooling in Air-Gapped K8s: An Overview of Solutions - DevSecOps Days 26

This repository contains supplemental material relating to the presentation.

* Hauler - Contains example manifests for adding to a Hauler Store
* k3d - Directory to deploy and setup an "air-gapped" k3s cluster using k3d. 
    * You must have k3d installed and setup before it can be used.
    * This was tested on an arm64 Linux host. 
* webapp - Contains the web application
    * zarf - Contains a zarf package to deploy the web application. 
    * k8s - Contains k8s manifests to deploy in a normal situation. 
* zarf - Contains example zarf package to deploy cloudnative-pg in the cluster. 