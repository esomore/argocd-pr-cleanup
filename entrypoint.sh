#!/bin/bash

KUBECONFIG=${1}
PR_REF= ${2}

echo ${{KUBECONFIG}} | base64 -d > ./kubeconfig.yaml
echo ">>>> kubeconfig created"

REGEX="[a-zA-Z]+-[0-9]{1,5}"
if [[ $PR_REF =~ $REGEX ]]; then
    export NAMESPACE=$(echo ${BASH_REMATCH[0]} | tr '[:upper:]' '[:lower:]')
else
    echo ">>>> $PR_REF is not a feature branch, nothing to cleanup"
    exit 0
fi

if [[ $(kubectl --kubeconfig=./kubeconfig.yaml -n argocd get application $NAMESPACE) ]]; then
    echo ">>>> Argo Application exist, Deleating now..."
    kubectl --kubeconfig=./kubeconfig.yaml -n argocd delete application $NAMESPACE
else
    echo ">>>> Argo Application Does not exist, nothing to clean. OK!"
fi
