#!/usr/bin/env bash

CLUSTER_DOMAIN=$(oc get dns cluster -o jsonpath='{ .spec.baseDomain }')

# Create Kubernetes Secret yaml
cat <<EOF > mq-self-signed-ca-certificate.yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: mq-self-signed-ca-cert
  annotations:
    argocd.argoproj.io/sync-wave: "260"
  labels:
    gitops.tier.group: cntk
spec:
  commonName: any.common.name
  isCA: true
  dnsNames:
    - >- 
      *.${CLUSTER_DOMAIN}
  secretName: mq-self-signed-ca-cert
  issuerRef:
    group: cert-manager.io
    kind: ClusterIssuer
    name: selfsigned-cluster-issuer
EOF