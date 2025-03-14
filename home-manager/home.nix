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
    # unstablePkgs.emacs # Use unstable Emacs
  ];
  home.sessionVariables = { };
  programs.home-manager.enable = true;
}
