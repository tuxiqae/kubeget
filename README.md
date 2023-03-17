# KubeGet

## Description
Lists pods for the configured Kubernetes cluster

## Installation
- Use [PDM](https://github.com/pdm-project/pdm) or any other Python package manager to install the package

- Use [Nix Flakes](https://nixos.wiki/wiki/Flakes) to build:
```shell
# The easiest -- running a Nix Development shell
⤅ nix develop
⤅ which kubeget # /nix/store/z3w2pqdc9yviji4lkai2zhq8ycnavbzk-python3-3.10.10-env/bin/kubeget
⤅ kubeget
```
```shell
# Containerized
⤅ nix build && docker image load --input result # In order to build the OCI image`
⤅ docker container run -it --rm kubeget:0.2.0 # Spin-up a Docker container using the previously built OCI image
```
```shell
# Install the package
⤅ nix build ".#app"
⤅ ./result/bin/kubeget
```

## Usage

```
⤅ kubeget --help
Usage: kubeget [OPTIONS]

Options:
  --namespace TEXT
  --node TEXT
  --show-traces
  --version         Show the version and exit.
  --help            Show this message and exit.

```

Or just watch the cool demo I made using [VHS](https://github.com/charmbracelet/vhs)
![Made with VHS](https://vhs.charm.sh/vhs-CTkiGV0A4paCy9NgmKu7q.gif)
