# Kronos HCA

Deploy HCA application on kubernetes.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| k8sRepo | string | `"gcr.io/gcp-keng01/"` | Container Registry. |
| backend.image.prefix | string | `"hca-backend-tomcat"` | Image to use for the backend app container. |
| backend.image.suffix | string | `"develop-k8s"` | Image suffix. |
| backend.image.tag | string | `"181"` | Tag number of Image. |

More to be fill once helm chart is finalized

References:

- [HCA Design Analysis](https://engconf.int.kronos.com/pages/viewpage.action?spaceKey=FAR&title=HCA+Design+in+Kubernetes)

- [HCA Service Image Creation process](https://engconf.int.kronos.com/display/FAR/HCA+Service+Docker+Image+creation+process)