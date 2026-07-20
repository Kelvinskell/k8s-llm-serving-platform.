## Baseline Test: Exclusive GPU Behavior (No Time-Slicing or MIG)

### Goal
Capture default scheduler behavior when GPU sharing mode is not enabled.

### Apply scenario
```bash
kubectl apply -f load-testing/scenarios/gpu-baseline-exclusive.yaml
````

### Observe behaviour using the following commands

```bash
kubectl -n gpu-baseline get pods -o wide
kubectl -n gpu-baseline describe pod gpu-b
kubectl describe node | grep -A8 -i allocatable
```

Expected pattern:

* `gpu-a` is `Running`.
* `gpu-b` remains `Pending`.
* Scheduler reports insufficient `nvidia.com/gpu` resources.

### Optional: Verify GPU access from running workload

Exec into the running pod:

```bash
kubectl exec -it -n gpu-baseline gpu-a -- sh
```

Verify GPU visibility:

```bash
nvidia-smi
```

Check current VRAM usage:

```bash
nvidia-smi --query-gpu=memory.used,memory.total --format=csv
```

Monitor GPU state continuously:

```bash
nvidia-smi -l 1
```

Verify GPU device mounts:

```bash
ls -l /dev/nvidia*
```

Check container CUDA version:

```bash
echo $CUDA_VERSION
```

Confirm base image behaviour:

```bash
nvcc --version
```

Expected pattern:

* `nvcc: not found`

### Cleanup

```bash
kubectl delete -f load-testing/scenarios/gpu-baseline-exclusive.yaml
```