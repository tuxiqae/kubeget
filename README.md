# KubeGet

## Description
Lists pods for the configured Kubernetes cluster

## Installation
Use [PDM](https://github.com/pdm-project/pdm) or any other Python package manager to install the package

You could also roll-up a Docker container which contains `kubeget`, and `kubectl` using the following command:
`
⤅ docker compose -f docker-compose.yml --env-file app.env run --build kubeget
`

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
