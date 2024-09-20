{ pkgs ? (import ../. {}).obelisk.nixpkgs
}:
let
  # The nixified node project was generated from a package.json file in src using node2nix
  # See https://github.com/svanderburg/node2nix#using-the-nodejs-environment-in-other-nix-derivations
  nodePkgs = (pkgs.callPackage ./src/node { nodejs = nixos-unstable.nodejs-14_x; }).shell.nodeDependencies;

  # This is a newer nixpkgs pin to unstable to get a much newer version of node that supports ES6 module imports,
  # this is necessary to use a newer version of tailwind (as we need a newer postcss that requires node 12 or higher)
  nixos-unstable = import (builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixos-unstable";
    # Commit hash for nixos-unstable as of 2018-09-12
    url = "https://github.com/NixOS/nixpkgs/archive/b67e752c29f18a0ca5534a07661366d6a2c2e649.tar.gz";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "1n47f7r8cm9pcsz7vl4nxjfvs0fgzvcmjda5h0inz3yx9vghp5xm";
  }) {};

  # The frontend source files have to be passed in so that tailwind's purge option works
  # See https://tailwindcss.com/docs/optimizing-for-production#removing-unused-css
  frontendSrcFiles = ../frontend;

in pkgs.stdenv.mkDerivation {
  name = "static";
  src = ./src;
  buildInputs = [pkgs.nodejs];
  installPhase = ''
    mkdir -p $out/css
    mkdir -p $out/images

    # Setting up the node environment:
    ln -s ${nodePkgs}/lib/node_modules ./node_modules
    export PATH="${nodePkgs}/bin:$PATH"

    # We make the frontend haskell source files available here:
    # This corresponds to the path specified in tailwind.config.js
    ln -s ${frontendSrcFiles} frontend

    

    # We can write other commands to produce more static files as well:
    cp -r images/* $out/images/

    ########################################################
    # Static HTML Files
    ########################################################
    mkdir -p $out/html
    cp -r html/* $out/html/
    ln -s $out/html/ html

    echo "HTMLDIR" 
    ls html > $out/test.txt
    touch $out/test2.txt
    ls frontend > $out/test2.txt


    # Run the postcss compiler:
    postcss css/styles.css -o $out/css/styles.css


    ########################################################
    # JavaScript Files
    ########################################################  
    mkdir -p $out/js
    cp -r js/* $out/js/

    ########################################################
    # Images
    ########################################################
    mkdir -p $out/images
    cp -r images/* $out/images/

    ########################################################
    # Videos
    ########################################################
    mkdir -p $out/videos
    cp -r videos/* $out/videos/

    ########################################################
    # Audio Files
    ########################################################
    mkdir -p $out/audio
    cp -r audio/* $out/audio/

    ########################################################
    # Favicons
    ########################################################
    mkdir -p $out/favicons
    #${pkgs.unzip}/bin/unzip favicons/favicon_package_v0.16.zip -d $out/favicons/
  '';
}
