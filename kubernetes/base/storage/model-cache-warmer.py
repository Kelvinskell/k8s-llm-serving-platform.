import os
from pathlib import Path

from huggingface_hub import snapshot_download


def parse_model_ids(raw: str) -> list[str]:
    # MODEL_IDS is a multi-line env var. Each non-empty line is one HF repo id.
    return [line.strip() for line in raw.splitlines() if line.strip()]


def ensure_model_cached(cache_root: Path, model_id: str, revision: str) -> None:
    # Keep each model under <cache_root>/<model_id>/<revision>.
    target = cache_root / model_id / revision
    ready = target / ".ready"

    # Fast path for idempotency: if a previous run completed, skip re-download.
    if ready.exists():
        print(f"[skip] already cached: {model_id}@{revision}")
        return

    target.mkdir(parents=True, exist_ok=True)
    print(f"[download] {model_id}@{revision} -> {target}")

    # Download full repository snapshot to node-local hostPath.
    snapshot_download(
        repo_id=model_id,
        revision=revision,
        local_dir=str(target),
        max_workers=4,
    )

    # Marker file to make subsequent runs safe and fast.
    ready.touch()
    print(f"[done] {model_id}@{revision}")


def main() -> None:
    cache_root = Path(os.environ["CACHE_ROOT"])
    revision = os.getenv("MODEL_REVISION", "main")
    model_ids = parse_model_ids(os.environ["MODEL_IDS"])

    if not model_ids:
        raise ValueError("MODEL_IDS is empty. Provide at least one model id.")

    cache_root.mkdir(parents=True, exist_ok=True)

    for model_id in model_ids:
        ensure_model_cached(cache_root, model_id, revision)


if __name__ == "__main__":
    main()
