# Kiteworks Infrastructure

Terraform provisions the Kiteworks AKS environments, shared ACR, and the static public IP resources used by NGINX Ingress.

## Ingress architecture

Each selected AKS cluster receives:

- One Standard static Azure public IP in the AKS node resource group.
- One Azure-provided DNS name using `centralus.cloudapp.azure.com`.
- One NGINX Ingress Controller installed by the infrastructure pipeline.

The application repository keeps the application Service private (`ClusterIP`) and defines the HTTP Ingress rules that Argo CD applies.

## Pipeline parameters

Run `azure-pipelines.yml` with:

- `targetEnvironment`: `dev`, `staging`, or `all`.
- `installNginxIngress`: install or upgrade NGINX and bind it to the Terraform public IP.
- `installArgoCD`: install Argo CD and apply its environment Application manifests.

The current MVP uses HTTP and Azure-provided DNS names. TLS, custom DNS, and WAF are follow-up improvements.

## Apply order

1. Run the infrastructure pipeline with `installNginxIngress=true`.
2. Run it with `installArgoCD=true` if Argo CD is not already installed.
3. Push the application GitOps manifests.
4. Verify the Ingress address and application rollout with `kubectl`.

The public endpoint is owned by NGINX, not by the application Service.
