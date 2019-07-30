#!/usr/bin/env bash

echo "allow egress to any pod, but external IPs are still blocked - expected timeout"
cat <<EOF | kubectl create -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: foo-deny-external-egress
spec:
  podSelector:
    matchLabels:
      run: curl
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector: {}
    ports:
    - protocol: UDP
      port: 53
    - protocol: UDP
      port: 54 # open 54 too in case tufindns is installed
    - port: 80
      protocol: TCP
  - to:
    - namespaceSelector: {}
EOF

kubectl run curl --image=opensona/router-docker
sleep 10
! kubectl exec $(kubectl get pods -o name | grep -m1 curl | cut -d'/' -f 2) -- curl --max-time 5 -s -o /dev/null -w "%{http_code}" www.google.com
success=$?

kubectl delete deploy curl

exit $success
