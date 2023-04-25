{ inputs, installShellFiles }: _final: prev: {
  rtx = (prev.extend inputs.rtx-flake.overlay).rtx.overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ installShellFiles ];

    postInstall = (oldAttrs.postInstall or "") + ''
      installManPage ./man/man1/rtx.1
      installShellCompletion \
        ./completions/rtx.{bash,fish} \
        --zsh ./completions/_rtx
    '';
  });
}
