# Create a namespace for OADP
oc create namespace oadp-operator

# Install the OADP Operator via OperatorHub
cat <<EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: oadp-operator-subscription
  namespace: oadp-operator
spec:
  channel: stable
  name: oadp-operator
  source: community-operators
  sourceNamespace: openshift-marketplace
EOF
