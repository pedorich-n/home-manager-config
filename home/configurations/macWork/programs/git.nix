{
  programs.git = {
    settings = {
      url = {
        "https://github.com/".insteadOf = [
          "ssh://git@github.com/"
          "git@github.com:"
        ];
      };

      user = {
        name = "Mykyta Pedorich";
        email = "mykyta.pedorich@paidy.com";
      };
    };

    signing = {
      format = "openpgp";
      key = "BB80A0D1C0EF81CD";
      signByDefault = true;
    };
  };
}
