{
  targets.genericLinux.gpu = {
    enable = true;

    nvidia = {
      enable = true;
      # Use `nvidia-smi --query-gpu=driver_version --format=csv,noheader`
      version = "615.71.09";
      # Use `nix store prefetch-file https://download.nvidia.com/XFree86/Linux-x86_64/@VERSION@/NVIDIA-Linux-x86_64-@VERSION@.run`
      sha256 = "sha256-zc7tIrvrYSSNGm3qvCWWZz46ZQFpjucayNL9wo87cP4=";
    };
  };
}
