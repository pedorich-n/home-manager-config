{
  programs.git = {
    settings = {
      url = {
        "https://github.com/".insteadOf = [
          "ssh://git@github.com/"
          "git@github.com:"
        ];
      };
    };
  };
}
