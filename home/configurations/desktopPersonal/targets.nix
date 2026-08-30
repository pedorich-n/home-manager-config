{
  targets.genericLinux.gpu = {
    enable = true;

    nvidia = {
      enable = true;
      # Use `nvidia-smi --query-gpu=driver_version --format=csv,noheader`
      version = "610.57.04";
      # Use `nix store prefetch-file https://download.nvidia.com/XFree86/Linux-x86_64/@VERSION@/NVIDIA-Linux-x86_64-@VERSION@.run`
      sha256 = "sha256-suk1xmuDuwDAyFe8jg7g/VLekoa0DJzB7sKafOfrEW0=";
    };
  };
}
