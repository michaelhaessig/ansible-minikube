#!/bin/sh

#export MINIKUBE_WANTUPDATENOTIFICATION=false
#export MINIKUBE_WANTREPORTERRORPROMPT=false
export MINIKUBE_HOME=$HOME
export CHANGE_MINIKUBE_NONE_USER=true
mkdir $HOME/.kube || true
touch $HOME/.kube/config

export KUBECONFIG=$HOME/.kube/config

# sudo -E ( --preserve-env ) 
sudo -E minikube start --vm-driver=none --extra-config=apiserver.ServiceNodePortRange=1000-32767

# this for loop waits until kubectl can access the api server that Minikube has created
for i in {1..150}; do # timeout for 5 minutes
   kubectl get po &> /dev/null
   if [ $? -ne 1 ]; then
      break
  fi
  sleep 2
done

echo "=> happy hacking !"
