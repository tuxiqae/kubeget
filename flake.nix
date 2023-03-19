{
  description = "A cool CLI utility that lists pods using K8s API";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix2container.url = "github:nlewo/nix2container";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nix2container,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      nix2containerPkgs = nix2container.packages.x86_64-linux;
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
      kubegetOci = nix2containerPkgs.nix2container.buildImage {
        name = "kubeget";
        tag = "0.2.0";
        config = {
          cmd = ["${app}/bin/kubeget"];
        };
        copyToRoot = [
          (pkgs.buildEnv {
            name = "root";
            paths = [app];
            pathsToLink = ["/bin"];
          })
        ];
        maxLayers = 120;
      };
      kubeget-devOci = nix2containerPkgs.nix2container.buildImage {
        name = "kubeget-dev";
        tag = "0.2.0";
        fromImage = kubegetOci;
        config = {
          cmd = ["/bin/bash"];
        };
        copyToRoot = [
          (pkgs.buildEnv {
            name = "root";
            paths = [app pkgs.bashInteractive pkgs.coreutils pkgs.awscli2 pkgs.kubectl];
            pathsToLink = ["/bin"];
          })
        ];
        maxLayers = 120;
      };
    in {
      packages = {
        default = kubegetOci;
        image = kubegetOci;
        dev-image = kubeget-devOci;
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
