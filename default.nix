{ system ? builtins.currentSystem
, obelisk ? import ./.obelisk/impl {
    inherit system;
    iosSdkVersion = "13.2";
    config = {
      allowBroken = true;
    };
    # You must accept the Android Software Development Kit License Agreement at
    # https://developer.android.com/studio/terms in order to build Android apps.
    # Uncomment and set this to `true` to indicate your acceptance:
    config.android_sdk.accept_license = true;

    # In order to use Let's Encrypt for HTTPS deployments you must accept
    # their terms of service at https://letsencrypt.org/repository/.
    # Uncomment and set this to `true` to indicate your acceptance:
    terms.security.acme.acceptTerms = true;
  }
}:
with obelisk;
project ./. ({ pkgs, hackGet, ... }@args:
  let
    thunkSet = pkgs.thunkSet ./thunks;
    haskellLib = pkgs.haskell.lib;
    monoid-subclasses_1_1_pkg =
      let
        pkgs = import (builtins.fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/05ae01fcea6c7d270cc15374b0a806b09f548a9a.tar.gz";
        }) {};
      in pkgs.haskellPackages.monoid-subclasses;
    reflex-dom-echartsSrc = pkgs.fetchFromGitHub {
      owner = "augyg";
      repo = "reflex-dom-echarts";
      rev = "3652e0d375e9fd808c587c17ec0e85ca8fc5f889";
      sha256 = "sha256-F2mc3Tyt5Bb3GLKS3sQlKuoOhNDx5Q572+kE0uE2rXk=";
    };
    echarts-jsdomSrc = pkgs.fetchFromGitHub {
      owner = "augyg";
      repo = "echarts-jsdom";
      rev = "aaffb109ef01a449b36bb6d27be8111bb72ae0dc";
      sha256 = "sha256-RHzKD+LBs6DkNlGwd9Xnh8VIbygN6GCEnHmtezbgUHA=";
    };
    # p = (import (builtins.fetchTarball {
    #     url = "https://github.com/NixOS/nixpkgs/archive/79b3d4bcae8c7007c9fd51c279a8a67acfa73a2a.tar.gz";
    # }) {}); #.haskellPackages.ghc.ghc-syntax-highlighter;

    # Should work with GHC-8.10.7
    p_ghcSyntax = import (builtins.fetchGit {
      # Descriptive name to make the store path easier to identify
      name = "my-old-revision";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "d1c3fea7ecbed758168787fe4e4a3157e52bc808";
    }) {};
    ghc-syntax-highlighter_0_0_6 = p_ghcSyntax.haskellPackages.ghc-syntax-highlighter;
    # #ghc-syntax-highlighter_0_0_7 = p.haskellPackages.ghc-syntax-highlighter;

    # TODO(use same nixpkgs for ghc-lib-parser and ghc-syntax-highlighter)
    # They are the same ones
    p_ghc-lib-parser_8_10_7 = import (builtins.fetchGit {
      # Descriptive name to make the store path easier to identify
      name = "my-old-revision";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "d1c3fea7ecbed758168787fe4e4a3157e52bc808";
    }) {};

    ghc-lib-parser_8_10_7 = p_ghc-lib-parser_8_10_7.haskellPackages.ghc-lib-parser;
    p_mmark-ext =
      import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify
         name = "my-old-revision";
         url = "https://github.com/NixOS/nixpkgs/";
         ref = "refs/heads/nixpkgs-unstable";
         rev = "d1c3fea7ecbed758168787fe4e4a3157e52bc808";
     }) {};
    
    mmark-ext_1 = p_mmark-ext.haskellPackages.mmark-ext;

    #mmark_ace =
    p_mmark_0_0_7_6 = import (builtins.fetchGit {
      # Descriptive name to make the store path easier to identify
      name = "my-old-revision";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "05bbf675397d5366259409139039af8077d695ce";
    }) {};

    mmark_0_0_7_6 = p_mmark_0_0_7_6.haskellPackages.mmark;
        
  in 
    {
#       packages = {
#         obelisk-oauth-common = (hackGet ./thunks/obelisk-oauth) + "/common";
#         obelisk-oauth-backend = (hackGet ./thunks/obelisk-oauth) + "/backend";
#         stripe-haskell = (hackGet ./thunks/stripe) + "/stripe-haskell";
#         stripe-core = (hackGet ./thunks/stripe) + "/stripe-core";
#         stripe-http-client = (hackGet ./thunks/stripe) + "/stripe-http-client";
#         stripe-http-streams = (hackGet ./thunks/stripe) + "/stripe-http-streams";
#         stripe-tests = (hackGet ./thunks/stripe) + "/stripe-tests";
# #        reflex-classhss = super.callPackage thunkSet.reflex-classh {}; 
#       };
      overrides = #pkgs.lib.composeExtensions
        # (pkgs.callPackage (hackGet ./thunks/rhyolite) args).haskellOverrides
        (self: super: with pkgs.haskell.lib; {
          # beam-automigrate = doJailbreak (self.callCabal2nix "beam-automigrate" (hackGet ./thunks/beam-automigrate) {});
          # bytestring-aeson-orphans = doJailbreak (super.bytestring-aeson-orphans);
          # ClasshSS = super.callPackage (thunkSet.ClasshSS) {}; 
          # #dependent-sum-aeson-orphans = doJailbreak (super.dependent-sum-aeson-orphans);
          
          # parseargs = dontCheck (super.parseargs);
          # reflex-classhss = super.callPackage thunkSet.reflex-classh {}; 
          # reflex-dom-echarts = self.callCabal2nix "reflex-dom-echarts" reflex-dom-echartsSrc {};
          # echarts-jsdom = self.callCabal2nix "echarts-jsdom" echarts-jsdomSrc {};

          # vessel = (super.vessel);
          #ghc-syntax-highlighter = doJailbreak (ghc-syntax-highlighter_0_0_7);
          #mmark-ext = doJailbreak (dontCheck ( (mmark-ext_1)));
          # mmark = dontCheck mmark_0_0_7_6;
          #mmark = doJailbreak (self.callCabal2nix "mmark" (hackGet ./thunks/mmark) {}); 
          #mmark = dontCheck (p_mmark-ext.haskellPackages.mmark);

          # https://github.com/NixOS/nixpkgs/issues/170897
          # https://github.com/NixOS/nixpkgs/issues/169332#issuecomment-1106552971
          ghc-syntax-highlighter = ghc-syntax-highlighter_0_0_6;#(super.ghc-syntax-highlighter);
          mmark-ext = dontHaddock (doJailbreak (self.callCabal2nix "mmark-ext" (hackGet ./thunks/mmark-ext) {})); 
          # my-mmark = doJailbreak (self.callCabal2nix "my-mmark" (hackGet ./thunks/my-mmark) {}); 

          
          #ghc-lib-parser = ghc-lib-parser_8_10_7; # (super.ghc-lib-parser);

          # snap-extras = doJailbreak (super.snap-extras);
          # stripe-core = doJailbreak (super.stripe-core);
          # stripe-http-client = doJailbreak (super.stripe-http-client);
          # stripe-tests = doJailbreak (super.stripe-tests);
          # scrappy-core = super.callPackage (thunkSet.scrappy-core) {}; #scrappy-corePkg;
          # scrappy-template = super.callPackage (thunkSet.scrappy-template) {};
          # gargoyle-postgresql-nix = haskellLib.overrideCabal super.gargoyle-postgresql-nix {
          #   librarySystemDepends = [ pkgs.postgresql_11 ];
          # };
          # backend = haskellLib.overrideCabal super.backend {
          #   librarySystemDepends = [
          #     pkgs.ffmpeg
          #   ];
          # };
        });
#      staticFiles = import ./static {inherit pkgs; };
      android.applicationId = "systems.obsidian.obelisk.examples.rhyolite";
      android.displayName = "Rhyolite Example App";
      ios.bundleIdentifier = "systems.obsidian.obelisk.examples.rhyolite";
      ios.bundleName = "Rhyolite Example App";
    }
)
