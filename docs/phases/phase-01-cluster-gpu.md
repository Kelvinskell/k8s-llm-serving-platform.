# Phase 01 - Cluster and GPU Scheduling

## Objective
Run GPU workloads reliably on EKS and verify Kubernetes-level GPU scheduling is functional for inference workloads.

## Scope
Included:
- EKS cluster and managed node groups (CPU + GPU).
- NVIDIA device plugin deployment as a self-managed add-on via Terraform Helm provider.
- GPU node scheduling constraints (labels and taints).
- Validation that GPU resources are visible to Kubernetes scheduler.

Excluded (this phase):
- Prometheus/Grafana observability stack.
- Serving stack (vLLM/KServe).
- Production autoscaling policies.

## Deliverables
- Terraform-managed GPU node group with explicit NVIDIA AMI type.
- Terraform-managed NVIDIA device plugin Helm release.
- Runbook for plugin verification and troubleshooting.
- Evidence that `nvidia.com/gpu` is allocatable on GPU node(s).

## Definition of Done
- [x] Cluster nodes with GPU are joinable and schedulable.
- [x] NVIDIA device plugin is healthy.
- [ ] At least 2 test pods can share GPU capacity (time-slicing or configured sharing mode).
- [x] Pod scheduling constraints and resource requests are documented.

## Implementation Notes
- Node group module now sets explicit GPU AMI type (`AL2023_x86_64_NVIDIA`) to avoid non-NVIDIA node images.
- NVIDIA device plugin is managed from Terraform module:
	- `terraform/modules/nvidia-device-plugin`
- Plugin scheduling aligns with nodegroup policy:
	- GPU node label: `gpu=true`
	- GPU node taint: `nvidia.com/gpu=true:NoSchedule`

## Evidence Collected
- Plugin pod is healthy:
	- `kubectl -n kube-system get pods -l app.kubernetes.io/name=nvidia-device-plugin`
	- observed: `1/1 Running`
- GPU resource is visible to scheduler:
	- `kubectl describe node | grep -A8 -i allocatable`
	- observed on GPU node: `nvidia.com/gpu: 1`
- Node labels show GPU placement intent:
	- `kubectl get nodes -L gpu,workload`

## Remaining Work to Close Phase 1
- Run and capture output for at least 2 concurrent GPU test pods.

## Related Docs
- Runbook: `docs/runbooks/phase-01-gpu-plugin-verification.md`
