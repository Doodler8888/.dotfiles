{
  description = "My NixOS configuration using flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";  # Defaults to nixos-unstable
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
      # extraPackages = pkgs: [
      #   (import /home/wurfkreuz/.dotfiles/nix/custom-emacs.nix { inherit pkgs; })  # Importing your custom Emacs derivation
      # ];
    };
  };
}
