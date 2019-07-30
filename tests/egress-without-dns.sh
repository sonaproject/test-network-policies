#!/usr/bin/env bash

echo "egress without DNS - expected timeout"
cat <<EOF | kubectl create -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default.balance
  namespace: default
spec:
  podSelector:
    matchLabels:
      run: curl
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: hello
  policyTypes:
  - Egress
EOF

kubectl run curl --image=opensona/router-docker
sleep 10
! kubectl exec $(kubectl get pods -o name | grep -m1 curl | cut -d'/' -f 2) -- curl --max-time 5 -s -o /dev/null -w "%{http_code}" hello:8080
success=$?

kubectl delete deploy curl

exit $success
