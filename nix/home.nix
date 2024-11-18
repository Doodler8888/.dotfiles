{ config, pkgs, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in

{

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
      zsh
      starship
      antigen
      zellij
      nil # It's a nix lsp.
      pyright
      clojure-lsp
      k9s
      lazydocker
      nixd
      (pkgs.nerdfonts.override {
	fonts = [
	  "Noto"
	];
      })
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
    '';
  };

 programs.starship.enableZshIntegration = true;

  nixpkgs = {
  #   overlays = [
  #     outputs.overlays.additions
  #     outputs.overlays.modifications
  #     outputs.overlays.unstable-packages
  #   ];
    config = {
      allowUnfree = true;
    };
  };

home = {
  username = "wurfkreuz";
  homeDirectory = "/home/wurfkreuz/";

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
};

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
