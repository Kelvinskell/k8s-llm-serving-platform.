# Deploy kube-prometheus-stack via Helm for cluster observability.
resource "helm_release" "kube_prometheus_stack" {
  count = var.enabled ? 1 : 0

  name             = var.release_name
  repository       = var.repository
  chart            = var.chart
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true

  # Ensure safer upgrades with rollback on failure.
  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = var.helm_timeout_seconds

  values = [
    yamlencode({
      # Install Prometheus Operator CRDs with the chart.
      crds = {
        enabled = true
      }

      # Keep Grafana enabled by default.
      grafana = {
        enabled = true
      }

      prometheus = {
        prometheusSpec = {
          retention                            = var.prometheus_retention
          storageSpec                          = local.prometheus_storage_spec
          # Allow selecting ServiceMonitors and PodMonitors beyond Helm-labeled objects.
          serviceMonitorSelectorNilUsesHelmValues = false
          podMonitorSelectorNilUsesHelmValues     = false
        }
      }
    })
  ]
}

# Install Metrics Server
resource "helm_release" "metrics_server" {
  count = var.enabled && var.enable_metrics_server ? 1 : 0

  name             = "metrics-server"
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  chart            = "metrics-server"
  version          = var.metrics_server_chart_version
  namespace        = "kube-system"
  create_namespace = false

  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = var.helm_timeout_seconds

  values = [
    yamlencode({
      args = [
        "--kubelet-insecure-tls",
        "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname"
      ]
    })
  ]
}