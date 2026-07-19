# Phase 01 Runbook: NVIDIA Device Plugin Verification (EKS)

## Purpose
Verify that GPU nodes expose `nvidia.com/gpu` and the NVIDIA device plugin is healthy after Terraform apply.

## Preconditions
- EKS cluster is up and reachable from your shell context.
- GPU node group is deployed with a NVIDIA-capable AMI type.
- GPU node group AMI type is explicitly set to a NVIDIA-enabled EKS AMI (for example `AL2023_x86_64_NVIDIA`).
- Terraform apply has completed successfully.

## Verification Commands

### 1) Check NVIDIA DaemonSet status
```bash
kubectl -n kube-system get ds | grep -i nvidia
```
What this checks:
- Plugin DaemonSet exists.
- `READY` and `AVAILABLE` are non-zero for `nvidia-device-plugin`.

Healthy pattern:
- `nvidia-device-plugin` shows `DESIRED >= 1`, `READY >= 1`, `AVAILABLE >= 1`.

### 2) Check plugin pod health
```bash
kubectl -n kube-system get pods -l app.kubernetes.io/name=nvidia-device-plugin
```
What this checks:
- Plugin pod is running on GPU node(s).

Healthy pattern:
- Pod status is `Running`.
- `READY` is `1/1`.
- `RESTARTS` stays low/stable.

### 3) Check node allocatable resources
```bash
kubectl describe node | grep -A8 -i allocatable
```
What this checks:
- Kubernetes advertises GPU resources from at least one node.

Healthy pattern:
- At least one node shows:
  - `nvidia.com/gpu: 1` (or higher)

### 4) Optional: Identify which nodes are GPU-ready
```bash
kubectl get nodes -L gpu,workload
```
What this checks:
- Node labels align with scheduling strategy.

Healthy pattern:
- GPU nodes are labeled `gpu=true` and workload label is present.

## Critical Note: GPU AMI Requirement
If GPU nodes are launched without a NVIDIA-enabled EKS AMI, the device plugin can deploy but fail at runtime, and `nvidia.com/gpu` will not appear in node allocatable resources.

Quick check (Terraform):
- In nodegroup config, ensure GPU node group sets `ami_type` to a NVIDIA AMI family.
- Current expected value in this project: `AL2023_x86_64_NVIDIA`.

## Troubleshooting Quick Path

### Symptom A: DaemonSet exists but pod is `Error`/`CrashLoopBackOff`
Likely cause:
- GPU node image/runtime is not NVIDIA-capable.
- Most common reason: GPU node group launched with a non-NVIDIA AMI type.

Actions:
1. Confirm GPU node group uses NVIDIA AMI type in Terraform.
2. Re-apply Terraform and allow node replacement.
3. Re-check plugin pod status.

### Symptom B: Plugin pod is Running but no `nvidia.com/gpu` in allocatable
Likely causes:
- Node runtime/driver issue.
- Plugin running on wrong node type.

Actions:
1. Confirm plugin node selector/taint tolerations target GPU nodes.
2. Check plugin logs:
```bash
kubectl -n kube-system logs -l app.kubernetes.io/name=nvidia-device-plugin --all-containers --tail=200
```
3. Confirm GPU instance types are used in node group.

### Symptom C: No plugin pod scheduled
Likely causes:
- No matching nodes for selector/taints.
- GPU node group scaled to zero.

Actions:
1. Check node labels and taints.
2. Ensure at least one GPU node is Ready.

## Evidence Capture for Phase 01
Capture and store outputs for:
1. DaemonSet status command.
2. Plugin pod status command.
3. Node allocatable output showing `nvidia.com/gpu`.
