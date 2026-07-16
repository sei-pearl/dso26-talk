# k3d setup

This directory was used during the talk to setup the k3d "airgap" cluster

start_cluster.sh and delete_cluster.sh will setup the environment assuming you are
on a Linux host. 

k3d-airgap.yaml is the configuration to create the k3s cluster. There is a 
registry entry to enable using the hauler registry being served from the jumpbox.