{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux"; # Adjust if needed
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations = {
        wurfkreuz = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ({ config, lib, ... }: {
              home.username = "wurfkreuz";
              home.homeDirectory = "/home/wurfkreuz";
              home.stateVersion = "24.11";

              fonts.fontconfig.enable = true;

              home.packages = with pkgs; [
		wofi
                k9s
		lazydocker
		swaynotificationcenter
		htop
		emacs30-gtk3
                (pkgs.nerdfonts.override {
                  fonts = [
                    "Noto"
                  ];
                })
              ];

              # programs.git = {
              #   enable = true;
              #   userName = "agud";
              #   userEmail = "agud@gear-games.com";
              # };


		#    programs.zsh = {
		#      enable = true;
		#      envExtra = ''
		# source ${pkgs.antigen}/share/antigen/antigen.zsh
		# '';
		#    };
		#
		#           programs.starship.enableZshIntegration = true;

	      #      home.file = {
	      #        ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "/home/wurfkreuz/.dotfiles/zsh/.zshrc";
	      #        ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/wurfkreuz/.dotfiles/nvim";
	      #        ".config/alacritty/alacritty.toml".source = config.lib.file.mkOutOfStoreSymlink "/home/wurfkreuz/.dotfiles/alacritty/alacritty.toml";
	      #        ".config/zellij/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "/home/wurfkreuz/.dotfiles/zellij/config.kdl";
	      #        ".config/k9s".source = config.lib.file.mkOutOfStoreSymlink "/home/wurfkreuz/.dotfiles/k9s";
	      # ".ssh".source = config.lib.file.mkOutOfStoreSymlink "/home/wurfkreuz/.secret_dotfiles/.ssh";
	      #      };

              programs.home-manager.enable = true;
            })
          ];
        };
      };
    };
}

