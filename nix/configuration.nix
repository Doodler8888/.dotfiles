# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # nix.nixPath = [
  #  "nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz"
  #  "nixos-config=/etc/nixos/configuration.nix"
  #  "/nix/var/nix/profiles/per-user/root/channels"
  # ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> {};
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  console.keyMap = "colemak";

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
    #jack.enable = true;
  };

  # I enabled xserver for a display manager, because with wayland it wasn't displaying some information correctly.
  services.xserver.enable = true;
  # services.displayManager.sddm.wayland.enable = true;

  services.displayManager.sddm.enable = true;

  # I need this so that i get colemak in display managers
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak";
  };

  # xdg.portal = {
  #   enable = true;
  #   wlr.enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  #   config.common.default = "gtk";
  # };

  services.gnome.gnome-keyring.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.wurfkreuz = {
    isNormalUser = true;
    description = "Urban Gorn";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [];
  };

  # fonts.fontDir.enable = true;
  # fonts.fontconfig.enable = true;

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
    grub2
    gcc
    clang
    cl
    zig
    python3
    cmake
    openssh
    git
    wget
    curl
    vim
    neovim
    pulseaudio # to have access to pactl
    hyprland
    opera
    vivaldi
    telegram-desktop
    grim
    slurp
    wl-clipboard
    mako
    alacritty
    fzf
    zoxide
    eza
    fd
    ripgrep
    zoxide
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
  # services.openssh.enable = true;

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
  system.stateVersion = "24.05"; # Did you read the comment?

}
