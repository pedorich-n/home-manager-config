{
  config,
  pkgs,
  ...
}:
{
  home = {
    username = "nikita";

    sessionVariables = {
      SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
    };

    packages = with pkgs; [
      jquake
      opentofu
      tofu-ls
      plannotator
    ];
  };
}
