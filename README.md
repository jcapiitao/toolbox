# DLRN image
``` bash
podman build -t dlrn:latest -f dlrn/Containerfile
podman run --privileged -v ~/workspace/dlrn-data:/DLRN/data -it dlrn:latest
```
