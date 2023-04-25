{ installShellFiles }: _final: prev: {
  rtx = prev.rtx.overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ installShellFiles ];

    postInstall = (oldAttrs.postInstall or "") + ''
      installManPage ./man/man1/rtx.1
      installShellCompletion \
        ./completions/rtx.{bash,fish} \
        --zsh ./completions/_rtx
    '';
  });
}
