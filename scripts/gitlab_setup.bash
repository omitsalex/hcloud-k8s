#!/usr/bin/env bash
set -eu

API_URL=$(kubectl cluster-info | grep 'Kubernetes master' | awk '/http/ {print $NF}')
CA_CERT=$(kubectl get secrets -o name | grep -o 'default-token-.*' | xargs -I % kubectl get secret % -o jsonpath="{['data']['ca\.crt']}" | base64 --decode)
kubectl apply -f https://gist.githubusercontent.com/NikoGrano/290b291f535703431ca6254498e2c9ae/raw/b60c5b27ed351d7cd4ba34c81bef996d67e355b5/gitlab-admin-service-account.yaml
TOKEN=$(kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep gitlab-admin | awk '{print $1}') | grep 'token:' | grep -oP ' \K.*' | sed 's/ //g')

echo "API URL: $API_URL"
echo "CA CERT: $CA_CERT"
echo "TOKEN  : $TOKEN"
