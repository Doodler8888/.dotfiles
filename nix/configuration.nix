{ pkgs, ... }:


{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> {};
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  console.keyMap = "colemak";

  networking.hostName = "nixos";

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

  environment.systemPackages = with pkgs; [
    grub2
    gcc
    libgccjit
    clang
    cl
    zig
    python3
    cmake
    openssh
    git
    wget
    curl
    jq
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
    wofi
    alacritty
    fzf
    zoxide
    eza
    fd
    ripgrep
    zoxide
    obs-studio
    vlc
    # emacs30
    # (import /home/wurfkreuz/.dotfiles/nix/emacs.nix { inherit pkgs; })
  ];

  system.stateVersion = "24.05";

}
