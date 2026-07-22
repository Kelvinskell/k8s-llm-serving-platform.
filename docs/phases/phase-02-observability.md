# Phase 02 - Infrastructure Observability

## Objective
Establish a working GPU observability pipeline for the EKS cluster by validating Prometheus scraping, DCGM exporter health, and GPU-related metric exposure for inference workloads.

## Scope
Included:
- Deployment of kube-prometheus-stack for cluster monitoring.
- Deployment of the NVIDIA DCGM exporter for GPU metrics.
- Prometheus target health validation.
- Verification that GPU metrics are available for utilization, memory usage, and node saturation.

Excluded:
- Grafana dashboard implementation as a primary deliverable.
- Application-level inference latency dashboards.
- Autoscaling policy changes.

## Deliverables
- Healthy Prometheus stack deployed in the monitoring namespace.
- DCGM exporter running on GPU-enabled nodes.
- Evidence that Prometheus scrapes GPU metrics successfully.
- Runbook for troubleshooting missing GPU metrics.

## Definition of Done
- [x] kube-prometheus-stack is installed and healthy.
- [x] DCGM exporter pods are running on GPU nodes.
- [x] Prometheus targets for DCGM exporter are healthy.
- [x] GPU metrics such as utilization and memory usage are queryable in Prometheus.

## Verification Commands
```bash
kubectl -n monitoring get pods
kubectl -n monitoring get servicemonitor | grep -i dcgm
kubectl -n monitoring get pods -l app.kubernetes.io/name=dcgm-exporter
kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090
```

## Prometheus Queries to Validate
```promql
DCGM_FI_DEV_GPU_UTIL
DCGM_FI_DEV_FB_USED
DCGM_FI_DEV_FB_FREE
100 * DCGM_FI_DEV_FB_USED / (DCGM_FI_DEV_FB_USED + DCGM_FI_DEV_FB_FREE)
```

## Evidence Collected
- Prometheus target health confirmed for the DCGM exporter.
- GPU metrics returned successfully from Prometheus queries.
- No missing scrape target or exporter crashloop was observed during validation.

## Related Docs
- Runbook: [docs/runbooks/dcgm-metrics-missing.md](../runbooks/dcgm-metrics-missing.md)
- Reference: [docs/runbooks/dcgm-prometheus-metrics-reference.md](../runbooks/dcgm-prometheus-metrics-reference.md)
