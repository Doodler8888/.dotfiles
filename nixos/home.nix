{ config, pkgs, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in

{

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    antigen
    nerd-fonts.noto
  ];

  programs.git = {
    enable = true;
    userName = "wurfkreuz";
    userEmail = "wurfkreuz@mail.ru";
  };

  programs.zsh = {
    enable = true;
    envExtra = ''
      source ${pkgs.antigen}/share/antigen/antigen.zsh
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
      bindkey '^Y' vi-quoted-insert
      bindkey '^R' fzf-history-widget
    '';
    # initExtra = ''
    #   source ${pkgs.fzf}/share/fzf/key-bindings.zsh
    #   source ${pkgs.fzf}/share/fzf/completion.zsh
    # '';
  };

 programs.starship.enableZshIntegration = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

home = {
  username = "wurfkreuz";
  homeDirectory = "/home/wurfkreuz";

  file.".zshrc" = {
    source = mkOutOfStoreSymlink "/home/wurfkreuz/.dotfiles/zsh/nix/.zshrc";
  };
  file.".config/nvim" = {
    source = mkOutOfStoreSymlink "/home/wurfkreuz/.dotfiles/nvim";
  };
  file.".config/alacritty/alacritty.toml" = {
    source = mkOutOfStoreSymlink "/home/wurfkreuz/.dotfiles/alacritty/alacritty.toml";
  };
  file.".config/zellij/config.kdl" = {
    source = mkOutOfStoreSymlink "/home/wurfkreuz/.dotfiles/zellij/config.kdl";
  };
  file.".config/k9s" = {
    source = mkOutOfStoreSymlink "/home/wurfkreuz/.dotfiles/k9s";
  };
  file.".config/i3/config" = {
    source = mkOutOfStoreSymlink "/home/wurfkreuz/.dotfiles/i3/nix/config";
  };
};

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
