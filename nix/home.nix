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
      nil
      pyright
      clojure-lsp
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

 # # Manage Zsh
 #  programs.zsh = {
 #    enable = true;
 #    # shellAliases = {
 #    #   rm = "rm -i";
 #    # };
 #    antigen = {
 #      enable = true;
 #      plugins = [
 # { name = "zsh-users/zsh-syntax-highlighting"; }
 # { name = "zsh-users/zsh-autosuggestions"; }
 # { name = "kutsan/zsh-system-clipboard"; }
 # { name = "marlonrichert/zsh-autocomplete"; }
 #      ];
 #    };
 #    # autosuggestions = {
 #    #   enable = true;
 #    #   strategy = [ "history" ];
 #    # };
 #    # defaultKeymap = "viins"; #emacs, vicmd, or viins
 #    # history = {
 #    #   size = 5000;
 #    #   extended = true;
 #    #   ignoreDups = true;
 #    #   ignoreSpace = true;
 #    #   save =5000;
 #    #   path = "/home/user1/.zsh_history";
 #    # };
 #    # envExtra = ''
 #    #   export PATH=$PATH:/home/user1/bin
 #    #   [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
 #    #   bindkey '^[[A' history-substring-search-up
 #    #   bindkey '^[[B' history-substring-search-down
 #    # '';
 #  };

  # xdg.portal = {
  #   enable = true;
  #   # wlr.enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  #   config.common.default = "gtk";
  # };

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
};

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
