resource "helm_release" "nvidia_device_plugin" {
  count = var.enabled ? 1 : 0

  name             = var.release_name
  repository       = var.repository
  chart            = var.chart
  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({
      config = {
        map = {
          default = yamlencode({
            version = "v1"
            sharing = {
              timeSlicing = {
                resources = [
                  {
                    name     = "nvidia.com/gpu"
                    replicas = var.time_slicing_replicas
                  }
                ]
              }
            }
          })
        }
        default = "default"
      }
      nodeSelector = {
        gpu = var.node_selector_gpu
      }
      tolerations = [
        {
          key      = var.taint_key
          operator = var.taint_operator
          value    = var.taint_value
          effect   = var.taint_effect
        }
      ]
      gfd = {
        enabled = var.gfd_enabled
      }
    })
  ]
}