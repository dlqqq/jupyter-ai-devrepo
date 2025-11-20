sync:
    git submodule foreach "git switch main && git pull"

build-all:
    #!/usr/bin/env bash
    # uv run --project .. ensures we don't create another uv.lock & .venv file in every submodule
    # important: the command passed to `foreach` must use single quotes to allow $name to be accessed
    git submodule foreach '
        if [ -f package.json ]
            then uv run --project .. jlpm && uv run --project .. jlpm build
            else echo "Skipping build in $name as it lacks a package.json file"
        fi;
    '

enable-server-extensions:
    #!/usr/bin/env bash
    # $name := name of submodule in the current iteration
    # ${name//-/_} := name with all '-' chars replaced with '_'
    git submodule foreach '
        # Skip jupyter-chat as it is a special case
        if [[ $name == "jupyter-chat" ]]
            then exit 0
        fi
        # Skip jupyter-ai-claude-code as it is not an extension
        if [[ $name == "jupyter-ai-claude-code" ]]
            then exit 0
        fi
        uv run --project .. jupyter server extension enable ${name//-/_}
    '
    # Enable jupyter-chat server extension imperatively
    uv run jupyter server extension enable jupyterlab_chat

enable-lab-extensions:
    #!/usr/bin/env bash
    git submodule foreach '
        # Skip jupyter-chat as it is a special case
        if [[ $name == "jupyter-chat" ]]
            then exit 0
        fi
        # Only enable labextension if submodule contains package.json
        if [ -f package.json ]
            then uv run --project .. jupyter labextension develop . --overwrite
            else echo "Skipping enabling labextension in $name as it lacks a package.json file"
        fi
    '
    # Enable jupyter-chat lab extension imperatively
    uv run jupyter labextension develop jupyter-chat/python/jupyterlab-chat --overwrite

enable-extensions: enable-server-extensions enable-lab-extensions

install: && build-all enable-extensions
    uv sync

uninstall:
    rm -rf .venv
    rm uv.lock

start:
    @# this always runs from the devrepo root
    uv run jupyter lab