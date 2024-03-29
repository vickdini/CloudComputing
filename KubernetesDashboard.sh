# Deploy the Kubernetes Dashboard from the master node:
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

# Create the admin user
cat <<EOF | sudo tee dashboard-adminuser.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

cat <<EOF | sudo tee dashboard-adminuser-ClusterRoleBinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

kubectl apply -f dashboard-adminuser.yaml
kubectl apply -f dashboard-adminuser-ClusterRoleBinding.yaml

# Get the token for the dashboard
echo "This is the dashboard token"
kubectl -n kubernetes-dashboard create token admin-user

# Then run:
kubectl proxy --address='0.0.0.0' --port=8001 --accept-hosts='.*'

echo "Connect via the master node's VM's public IP address: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
