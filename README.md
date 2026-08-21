# Kiteworks Infrastructure

Terraform provisions the Kiteworks AKS environments, shared ACR, and the static public IP resources used by NGINX Ingress.

## Ingress architecture

Each selected AKS cluster receives:

- One Standard static Azure public IP in the AKS node resource group.
- One Azure-provided DNS name in the environment's Azure region.
- One NGINX Ingress Controller installed by the infrastructure pipeline.

The default environment locations are `centralus` for dev, `eastus` for staging, and `eastus2` for prod. The shared ACR remains in Central US.

The application repository keeps the application Service private (`ClusterIP`) and defines the HTTP Ingress rules that Argo CD applies.

## Pipeline parameters

Run `azure-pipelines.yml` with:

- `targetEnvironment`: `dev`, `staging`, or `all`.
- `installNginxIngress`: install or upgrade NGINX and bind it to the Terraform public IP.
- `installArgoCD`: install Argo CD and apply its environment Application manifests.
- `destroyAfterDelay`: optionally destroy the selected environments after a delay.
- `destroyEverything`: immediately destroy all AKS environments while retaining the shared ACR; keep this `false` when using delayed destroy.

The pipeline also supports `targetEnvironment: none` for validation without provisioning. Staging and prod use East US and East US 2 to avoid the Central US public-IP quota; the shared ACR remains in Central US and survives environment teardown.

## Apply order

1. Run the infrastructure pipeline for the required environment.
2. Enable NGINX, cert-manager, and Argo CD when creating a cluster.
3. Push the application GitOps manifests.
4. Verify the Ingress address and application rollout with `kubectl`.

NGINX owns the public endpoint; application Services remain private `ClusterIP` services.
