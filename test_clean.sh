#!/usr/bin/env bash

CleanupNetworkPolicies () {
  for ns in $(kubectl get namespace -o jsonpath="{.items[*].metadata.name}"); do
    for np in $(kubectl get networkpolicies --namespace $ns -o jsonpath="{.items[*].metadata.name}"); do
      kubectl delete networkpolicies $np
    done
  done
}

echo ""
echo "deleting any leftover 'curl' pods..."
kubectl delete pod curl

echo ""
echo "resetting network policies..."
CleanupNetworkPolicies

echo "cleaning up..."
kubectl delete service hello
kubectl delete deployment hello
kubectl delete namespace second

