#!/bin/bash

if [ $# -eq 0 ]; then
  echo 1>&2 "$0 up/down"
  exit
fi

if [ "$1" == "up" ]; then
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

elif [ "$1" == "down" ]; then

  sudo -E minikube stop

  echo "=> Cleaning up containers"
  docker stop $(docker ps -q --filter name=k8s)
  docker rm $(docker ps -aq --filter name=k8s)
  echo "=> Kubernetes stopped"
fi
