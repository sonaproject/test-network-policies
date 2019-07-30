#!/usr/bin/env bash

echo "egress to all pods, prohibits access to the internet - expected timeout"
cat <<EOF | kubectl create -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-egress-all-pods
spec:
  podSelector: {}
  egress:
  - to:
    - podSelector: {}
  policyTypes:
  - Egress
EOF

kubectl run curl --image=opensona/router-docker
sleep 5
! kubectl exec $(kubectl get pods -o name | grep -m1 curl | cut -d'/' -f 2) -- curl --max-time 5 -s -o /dev/null -w "%{http_code}" www.google.com
success=$?

kubectl delete deploy curl

exit $success
