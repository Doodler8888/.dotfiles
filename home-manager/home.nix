{ config, pkgs, ... }:
let
  unstableTarball = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  unstablePkgs = import unstableTarball { config = config.nixpkgs.config; };
in
{
  home.username = "wurfkreuz";
  home.homeDirectory = "/home/wurfkreuz";
  home.stateVersion = "24.11"; # Don't change unless necessary

  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    swaynotificationcenter
    glibcLocales
    xplr
    hadolint
    shellcheck
    yaml-language-server
    lua-language-server
    ansible-lint
    pyright
    sqls
    kind
    wofi
    # nerd-fonts.noto
    # noto-fonts-emoji
    foot
    tmux
    direnv
    lazydocker
    lazygit
    k9s
    # obs-studio
    # unstablePkgs.emacs # Use unstable Emacs
  ];

  # # I don't like to use it, because you have to constantly execute the switch
  # # command after each time you do anything
  # home.file = {
  #   ".config/nvim".source = "/home/wurfkreuz/.dotfiles/nvim";
  #   ".config/sway".source = "/home/wurfkreuz/.dotfiles/sway";
  #   ".config/foot".source = "/home/wurfkreuz/.dotfiles/foot";
  #   ".config/alacritty".source = "/home/wurfkreuz/.dotfiles/alacritty";
  #   ".zshrc".source = "/home/wurfkreuz/.dotfiles/zsh/.zshrc";
  #   ".dirs".source = "/home/wurfkreuz/.dotfiles/scripts/sh/dirs/add-cd-dirs";
  #   ".tmux.conf".source = "/home/wurfkreuz/.dotfiles/tmux/.tmux.conf";
  # };


 # home.sessionVariables = {
 #   PATH = "$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:" + builtins.getEnv "PATH";
 #   XDG_DATA_DIRS = "/usr/local/share:/usr/share:$HOME/.nix-profile/share";
 # };
  #home.sessionVariables = {
  #  # EDITOR = "emacs";
  #};
  programs.home-manager.enable = true;
}
