{
  config,
  pkgs,
  ...
}:
let
  mkOllamaAutoComplete =
    {
      model,
      extraArgs ? { },
    }:
    {
      name = "Ollama ${model}";
      provider = "ollama";
      inherit model;
      apiBase = "http://${config.services.ollama.host}:${toString config.services.ollama.port}";
      roles = [
        "autocomplete"
      ];
      autocompleteOptions = {
        maxPromptTokens = 1024;
        debounceDelay = 350;
        onlyMyCode = true;
      };
    }
    // extraArgs;
in
{
  home.file = {
    ".continue/config.yaml".source = pkgs.writers.writeYAML "continue-config.yaml" {
      name = "Local Ollama";
      version = "0.0.1";
      schema = "v1";

      models = [
        (mkOllamaAutoComplete { model = "qwen2.5-coder:1.5b"; })
        (mkOllamaAutoComplete { model = "qwen2.5-coder:3b"; })
      ];
    };
  };
}
