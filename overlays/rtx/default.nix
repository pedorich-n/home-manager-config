{ installShellFiles, rtx-flake }: _final: prev:
(prev.extend rtx-flake.overlay).rtx.overrideAttrs (oldAttrs: {
  nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ installShellFiles ];

  postInstall = (oldAttrs.postInstall or "") + ''
    installManPage ./man/man1/rtx.1
    installShellCompletion \
      ./completions/rtx.{bash,fish} \
      --zsh ./completions/_rtx
  '';
})

