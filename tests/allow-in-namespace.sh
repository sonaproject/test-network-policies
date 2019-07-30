#!/usr/bin/env bash

echo "pods in same namespace (allow policy) - expected 200"
cat <<EOF | kubectl create -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default.allow-hello
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: hello
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          run: curl
EOF

kubectl run -it --rm --restart=Never curl --image=appropriate/curl --command -- curl --max-time 10 -s -o /dev/null -w "%{http_code}" hello:8080
success=$?

exit $success
