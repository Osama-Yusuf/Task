# helm install ingress-nginx ingress-nginx-4.5.2.tgz

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx

# first we create a namespace for the network policy
kubectl create namespace network-policy

# after that lets modifiy the k8s api service to only allow traffic from pods in the network-policy namespace:
kubectl patch svc kubernetes -p '{"spec":{"externalTrafficPolicy":"Local"},"metadata":{"annotations":{"metallb.universe.tf/allow-shared-ip":"network-policy"}}}'

cd ..

# applying the application resources
cd app
kubectl apply -f .
cd ..

# 
echo """
3.120.35.196 juice-app.obs-task.com
35.158.200.27 juice-app.obs-task.com
""" | sudo tee -a /etc/hosts