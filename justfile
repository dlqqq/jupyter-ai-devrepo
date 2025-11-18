sync:
    git submodule foreach "git switch main && git pull"

build-all:
    git submodule foreach "if [ -f package.json ]; then jlpm && jlpm build; else exit 0; fi"

enable-all-extensions:
    @# $name := name of submodule in the current iteration
    @# ${name//-/_} := name with all '-' chars replaced with '_'
    @# important: the command passed to foreach must use single quotes to allow $name to be accessed
    git submodule foreach 'jupyter server extension enable ${name//-/_}'
    git submodule foreach 'if [ -f package.json ]; then jupyter labextension develop . --overwrite; else exit 0; fi'

dev-install-all: build-all && enable-all-extensions
    uv pip install .
    echo "Developer installation complete!"
