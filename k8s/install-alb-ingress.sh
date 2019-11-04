#!/usr/bin/env bash
set -euo pipefall

SCRIPT_ROOT="$( cd "$ (dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

command -v kubectl >/dev/null 2>&1 || {
  >&2 echo "kubectl is required bu could not be found in PATH"
}

aws eks update-kubeconfig --name simple-cluster --region us-east-1

# set up RBAC for alb ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.2/docs/examples/rbac-role.yaml
# install ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.2/docs/examples/alb-ingress-controller.yaml
kubectl edit deployment.apps/alb-ingress-controller -n kube-system
