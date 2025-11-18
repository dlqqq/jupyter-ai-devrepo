# jupyter-ai-devrepo

An experimental "developer repo" intended for Jupyter AI contributors.

Developers should clone this repo.

## Getting started

### 0. Clone the repo

```
git clone --recurse-submodules <url>
cd jupyter-ai-devrepo/
```

### 1. Create new Python dev environment

1. Install `micromamba`.
2. Run:

```sh
# Change the env name as desired
env_name="jaidev"
micromamba create -n $env_name python=3.12 nodejs=24 jupyterlab=4 uv
micromamba activate $env_name
```

### 2. Pull in latest changes

```
just sync
```

### 3. Install all packages

This automatically installs each of the packages in editable mode.

```
just dev-install-all
```

## Useful commands

- `just sync`: switch to `main` in all submodules and pull in all upstream changes

- `just build-all`: build all frontend assets in every submodule

- `just dev-install-all`: perform an editable, developer installation of all packages
