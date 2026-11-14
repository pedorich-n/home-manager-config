{
  targets.genericLinux.gpu = {
    enable = true;

    nvidia = {
      enable = true;
      # Use `nvidia-smi --query-gpu=driver_version --format=csv,noheader`
      version = "620.70.06";
      # Use `nix store prefetch-file https://download.nvidia.com/XFree86/Linux-x86_64/@VERSION@/NVIDIA-Linux-x86_64-@VERSION@.run`
      sha256 = "sha256-KRGOOr0IwHVZvMo9nHYjjQOUkK8DYqLlvPy+cgSv1LE=";
    };
  };
}
