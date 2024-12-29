# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

#nix.settings = {
#    trusted-users = ["wurfkreuz"];
#    substituters = [
#  #     "https://cache.nixos.org/"
#       #"https://eu.nixos.org"
#       #"https://eu.cachix.org"
#   ];
#  };
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Minsk";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Sound
  # sound.enable = true;
  security.rtkit.enable = true; # rtkit is optional but recommended


  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

  # Keyboard
  console.keyMap = "colemak";

  # Configure keymap in X11
  services.xserver = {
enable = true;
xkbOptions = "caps:swapescape";
	  xkb = {
    layout = "us";
    variant = "colemak";
};
displayManager.sddm.enable = true;
windowManager.i3 = {
enable = true;
package = pkgs.i3;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
     ];
};
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.wurfkreuz = {
    isNormalUser = true;
    description = "Urban Gorn";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Enable system-wide fonts
  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;
  };

  # Set Zsh as the default shell
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  environment.variables = {
    EDITOR = "nvim";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   wget
   git
   gcc
   libgccjit
   clang
   cl
   zig
   python3
   gnumake
   cmake
   autoconf
   libtool
   openssh
   jq
   pulseaudio # for pactl
   rofi
   home-manager
   neovim
   alacritty
   #ghostty
   vivaldi
   telegram-desktop
   xclip  
   fzf
   fd
   zoxide
   direnv
   opera
   ripgrep
   zsh
   starship
   zellij
   nil # It's a nix lsp.
   pyright
   clojure-lsp
   k9s
   lazydocker
   nixd
   shellcheck
   eza
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
