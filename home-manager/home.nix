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
    yaml-language-server
    sqls
    kind
    # docker
    # docker-buildx
    # unstablePkgs.emacs # Use unstable Emacs
  ];

  # I've tried to use it, it doesn't change anything (maybe because i had git
  # from xbps installed at the same time?)
  # programs.git = {
  #   enable = true;
  #   userName  = "John Doe";
  #   userEmail = "johndoe@example.com";
  # };
    
  home.sessionVariables = { };
  programs.home-manager.enable = true;
}
