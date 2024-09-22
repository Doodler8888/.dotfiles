{ pkgs ? import <nixpkgs> {} }:

let
  emacsGitSrc = builtins.fetchGit {
    url = "https://github.com/emacs-mirror/emacs.git";
    ref = "master";
    # You can optionally specify a rev here if you want a specific commit
    # rev = "...";
  };
in
pkgs.stdenv.mkDerivation {
  pname = "custom-emacs";
  version = "git-${builtins.substring 0 8 emacsGitSrc.rev}";

  src = emacsGitSrc;

  nativeBuildInputs = with pkgs; [
    autoconf
    automake
    pkg-config
    texinfo
    gcc
  ];

  buildInputs = with pkgs; [
    gnutls
    libxml2
    ncurses
    libpng
    libjpeg
    libungif
    libtiff
    librsvg
    imagemagick
    gtk3
    webkitgtk
    tree-sitter
    jansson
    libgccjit
  ];

  configureFlags = [
    "--with-native-compilation=aot"
    "--with-tree-sitter"
    "--with-gif"
    "--with-png"
    "--with-jpeg"
    "--with-rsvg"
    "--with-tiff"
    "--with-imagemagick"
    "--with-x-toolkit=gtk3"
    "--with-xwidgets"
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  enableParallelBuilding = true;

  meta = with pkgs.lib; {
    description = "Custom build of GNU Emacs";
    homepage = "https://www.gnu.org/software/emacs/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
