zstyle ':znap:*' repos-dir ~/.zsh-plugins
source %zsh-snap%/znap.zsh

znap source ohmyzsh/ohmyzsh lib/{git,theme-and-appearance,history,key-bindings,misc,completion,directories,termsupport}
znap source ohmyzsh/ohmyzsh plugins/{git,command-not-found,extract,keychain,gpg-agent}
znap source ptavares/zsh-direnv

znap source ohmyzsh/ohmyzsh themes/fletcherm.zsh-theme

znap prompt ohmyzsh/ohmyzsh fletcherml