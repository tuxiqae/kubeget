{
  description = "A cool CLI utility that lists pods using K8s API";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        poetry_env = pkgs.poetry2nix.mkPoetryEnv {
          projectDir = ./.;
          preferWheels = true;
          python = pkgs.python310;
        };
        app = pkgs.poetry2nix.mkPoetryApplication ({
          projectDir = ./.;
          preferWheels = true;
          python = pkgs.python310;
        });
        ociImage = pkgs.dockerTools.buildLayeredImage {
          name = "kubeget";
          tag = "0.2.0";
          contents = [
            app.dependencyEnv
            pkgs.awscli2
            pkgs.bash
            pkgs.busybox
            pkgs.kubectl
          ];
          config.Cmd = [ "/bin/bash" ];
          maxLayers = 120;
          created = "now";
          # copyToRoot = [ pkgs.dockerTools.usrBinEnv pkgs.dockerTools.binSh ];
        };
      in
      {
        packages = { default = ociImage; image = ociImage; app = app; };
        devShells.default = poetry_env.env.overrideAttrs (old: {
          buildInputs = [
            app
            pkgs.awscli2
            pkgs.kubectl
            pkgs.podman
            pkgs.poetry
          ];
        });
      });
}

