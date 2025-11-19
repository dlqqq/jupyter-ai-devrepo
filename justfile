sync:
    git submodule foreach "git switch main && git pull"

build-all:
    @# uv run --project .. ensures we don't create another uv.lock & .venv file in every submodule
    @# important: the command passed to `foreach` must use single quotes to allow $name to be accessed
    git submodule foreach 'if [ -f package.json ]; then uv run --project .. jlpm && uv run --project .. jlpm build; else echo "Skipping build in $name as it lacks a package.json file"; fi'

enable-server-extensions:
    @# $name := name of submodule in the current iteration
    @# ${name//-/_} := name with all '-' chars replaced with '_'
    git submodule foreach 'uv run --project .. jupyter server extension enable ${name//-/_}'

enable-lab-extensions:
    git submodule foreach 'if [ -f package.json ]; then uv run --project .. jupyter labextension develop . --overwrite; else echo "Skipping enabling labextension in $name as it lacks a package.json file" ; fi'

enable-extensions: enable-server-extensions enable-lab-extensions

install: build-all && enable-extensions
    uv sync

uninstall:
    rm -rf .venv

start:
    @# this always runs from the devrepo root
    uv run jupyter lab