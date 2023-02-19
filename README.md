# DevOps Task

## Task 1 - Scripting with Bash & Python to Parse and Filter Users

### The script filters the lines to discard invalid emails & ids, and to identify whether the ID is an even or odd number. Then prints a message with the name of the user, their ID, and whether the ID is even or odd.

### Implementation:

1. Get the number of lines in the file using wc -l.
2. Loop through each line in the file and parse the name, email address, and ID using awk.
3. Check if the email address is valid by looking up the domain using dig. If the domain does not resolve, the email address is discarded.
4. Check if the ID is a number. If it is, store it in the ID variable. If it is not, the line is discarded.
5. Check if the ID is even or odd using the modulo operator %. Store the result in the isEven variable.
6. Print a message with the user's name, ID, and whether it is even or odd. 

### Example output:

```text
John ID:(325) of john@domain.com is odd number
--
Jane ID:(131) of jane@domain.com is odd number
--
Bert ID:(150) of bert@localhost is even number
--
```

## Task 2 - Create a Kubernetes cluster and Accessing the Kubernetes API

## 1. Create a Kubernetes cluster

### I've automated all the following steps using terraform and ansible to create a kubernetes cluster on AWS, You can take a look at the [GitHub project page](https://github.com/Osama-Yusuf/Kubernetes-init-cluster).

### To create a Kubernetes cluster, we will be using Kubeadm. We will create a single master node and a single worker node.

#### On both the master and worker nodes, install the necessary dependencies:

```bash
sudo apt update
sudo apt install -y docker.io curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

#### On the master node, initialize the Kubernetes control plane:

```bash
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
```

### This will download and install the necessary Kubernetes images, and then initialize the control plane.

#### Once the initialization is complete, copy the kubeconfig file to your user's home directory:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

#### On the master node, deploy a pod network add-on to allow communication between pods:

```bash
kubectl apply -f https://docs.projectcalico.org/v3.16/manifests/calico.yaml
```

#### Once the add-on is deployed, join the worker node to the cluster. On the worker node, run the kubeadm join command that was output at the end of the kubeadm init command.

```bash
sudo kubeadm join <master-node-ip>:<master-node-port> --token <token> --discovery-token-ca-cert-hash <hash>
```

### Replace <master-node-ip> and <master-node-port> with the IP address and port of the master node, and replace <token> and <hash> with the token and discovery token CA certificate hash that were output at the end of the kubeadm init command.

### After running this command, the worker node should join the cluster.

#### We can verify that the nodes are running and ready:

```bash
kubectl get nodes
```

### This should show both the master and worker nodes as Ready.

## 2. Restricting access to the Kubernetes API

### By default, the Kubernetes API is open and accessible to anyone who can access the cluster. To restrict access to the Kubernetes API to a set of IP addresses, we can create a NetworkPolicy that allows traffic only from those IP addresses.

#### Create a networkpolicy.yaml file with the following content:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: api-allow
spec:
  podSelector: {}
  ingress:
  - from:
    - ipBlock:
        cidr: 192.0.2.0/24
    - ipBlock:
        cidr: 203.0.113.0/24
```

### This policy allows traffic only from the IP addresses 192.0.2.0/24 and 203.0.113.0/24.

```bash
kubectl apply -f netWorkPolicy.yaml
```

## 3. Kubernetes resources (Juice Shop)
### The Juice Shop is a vulnerable web application that is designed to teach about web application security. It contains a variety of security vulnerabilities that can be exploited by users to learn about different types of attacks.

### First to deploy the Juice Shop, I created a deploy.yml, service.yml, and ingress.yml files. The deploy.yml file contains the deployment configuration for the Juice Shop. The service.yml file for makeing it internally accessible. The ingress.yml file for exposing the application externally.

### second I installed the nginx-ingress controller using helm.

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx
```

## in order to see the juice shop, you can go to the following link: [Juice Shop](http://juice-app.obs-task.com/)
## but before visiting the link, you have to add the following line to your hosts file:
```bash
3.120.35.196 juice-app.obs-task.com
35.158.200.27 juice-app.obs-task.com
```

## or you can use the following command:
```bash
echo """
3.120.35.196 juice-app.obs-task.com
35.158.200.27 juice-app.obs-task.com
""" | sudo tee -a /etc/hosts
```
### these are the two public IPs of the load balancer that is created by the ingress controller.