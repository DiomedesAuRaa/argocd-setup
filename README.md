# Argo CD Deployment

This repository contains the setup for Argo CD, a declarative, GitOps continuous delivery tool for Kubernetes.

## Deployment Details

- **Namespace**: `argocd`
- **Helm Release Name**: `argocd`
- **Ingress Host**: `argocd.example.com`
- **High Availability**: Enabled
- **Redis HA**: Enabled

## Accessing Argo CD

1. **Argo CD Server**: Access the Argo CD UI at `https://argocd.example.com`.
2. **Admin Password**: The initial admin password is:
   ```
   
   ```
   **Note**: Change the password after the first login.

## Managing Applications

- Use the `Application` CRD to define applications in Argo CD.
- Use the `ApplicationSet` CRD for managing multiple applications across clusters.

## Upgrading Argo CD

To upgrade Argo CD, run:
```bash
helm upgrade argocd argo/argo-cd --namespace argocd
```

## Backup and Recovery

- Regularly back up the `argocd` namespace using tools like Velero.
- Store backups in a secure location.

## Monitoring and Logging

- Enable Prometheus metrics for monitoring.
- Use centralized logging solutions (e.g., ELK, Loki) for log aggregation.

## Troubleshooting

- Check the logs of Argo CD components:
  ```bash
  kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server
  ```
- Refer to the [Argo CD Documentation](https://argo-cd.readthedocs.io/) for more details.

# argocd-setup
