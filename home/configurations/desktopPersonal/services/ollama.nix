{
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    environmentVariables = {
      OLLAMA_MAX_LOADED_MODELS = "1";
    };
  };
}
