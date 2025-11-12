# jupyter-ai-devrepo

An experimental "developer repo" intended for Jupyter AI contributors.

Developers should clone this repo.

## Getting started

### 0. Clone the repo

```
git clone --recurse-submodules <url>
cd jupyter-ai-devrepo/
git submodule update --remote
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

### 2. Install the package

This automatically installs each of the packages in editable mode.

```
uv pip install .
```

### 3. Enable local labextension development

TODO.

## Useful commands

- `git submodule update --remote`: pull in all upstream changes
