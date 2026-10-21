{
  config,
  ...
}:
{
  sops = {
    gnupg = {
      home = "${config.home.homeDirectory}/.gnupg";
    };

    secrets = {
    };
  };
}
