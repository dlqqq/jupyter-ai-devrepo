# jupyter-ai-devrepo

An experimental "developer repo" intended for Jupyter AI contributors.

By cloning the repo and following the steps below, you can have an editable
developer installation of all Jupyter AI subpackages.

## Getting started

### 0. Clone the repo

```
git clone --recurse-submodules <url>
cd jupyter-ai-devrepo/
```

### 1. Install root dependencies

This monorepo requires `git`, `uv`, and `just`.

No dedicated Python environment is required because `uv` automatically manages a
local venv.

If you use `conda`/`mamba`/`micromamba`, you can run the following commands to
install these dependencies into the `base` environment:

```sh
{conda,mamba,micromamba} activate base
{conda,mamba,micromamba} install uv just
# make sure to activate the `base` environment before working in this repo
```

Otherwise, you can use your OS's package manager. For example, on macOS:

```sh
brew install uv just
```

### 2. Pull in latest changes

This command switches to the `main` branch on every submodule and pulls from it.

```
just sync
```

### 3. Install all packages

This command automatically installs each of the packages in editable mode.

```
just dev-install-all
```

### 4. Start JupyterLab

Start JupyterLab by running:

```
just start
```

This command will always run `uv run jupyter lab` from the root of this devrepo,
even if your current directory is inside of a submodule.

## Useful commands

- `just start`: start JupyterLab

- `just sync`: switch to `main` in all submodules and pull in all upstream changes

- `just build-all`: build all frontend assets in every submodule

- `just dev-install-all`: perform an editable, developer installation of all packages

- `just uninstall`: uninstall everything (useful for testing the `just` commands)

- `just uninstall && just dev-install-all`: re-install everything (useful for fixing a broken venv)
