{
  description = "A cool CLI utility that lists pods using K8s API";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      poetry_env = pkgs.poetry2nix.mkPoetryEnv {
        projectDir = ./.;
        preferWheels = true;
        python = pkgs.python310;
      };
      app = pkgs.poetry2nix.mkPoetryApplication {
        projectDir = ./.;
        preferWheels = true;
        python = pkgs.python310;
      };
      ociImage = pkgs.dockerTools.buildLayeredImage {
        name = "kubeget";
        tag = "0.2.0";
        contents = [
          app.dependencyEnv
        ];
        config.Cmd = ["kubeget"];
        maxLayers = 120;
        created = "now";
      };
      devOciImage = pkgs.dockerTools.buildLayeredImage {
        name = "kubeget-dev";
        tag = "0.2.0";
        fromImage = ociImage;
        contents = [
          pkgs.awscli2
          pkgs.bashInteractive
          pkgs.busybox
          pkgs.kubectl
        ];
        config.Cmd = ["/bin/bash"];
        maxLayers = 120;
        created = "now";
      };
    in {
      packages = {
        default = ociImage;
        image = ociImage;
        dev-image = devOciImage;
        app = app;
        poetry_env = poetry_env;
      };
      formatter = pkgs.alejandra;
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
