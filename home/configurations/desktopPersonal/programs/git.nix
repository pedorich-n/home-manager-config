{

  programs.git = {
    settings.user = {
      name = "Nikita Pedorich";
      email = "pedorich.n@gmail.com";
    };

    signing = {
      format = "ssh";
      # `IdeaPad 5 Pro Git signing` in 1Password
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEzqXNCmFfcMEvB555kzW7oAPI7/ZkKZhO3UaO0cVjz8";
      signer = "/opt/1Password/op-ssh-sign";
      signByDefault = true;
    };
  };
}
