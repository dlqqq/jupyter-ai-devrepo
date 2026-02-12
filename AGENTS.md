# AGENTS.md

This file provides guidance to AI coding assistants when working with code in this repository.

## What This Is

A monorepo ("devrepo") for Jupyter AI development. It uses git submodules + uv workspaces to provide editable installs of all Jupyter AI packages in a single venv. Each submodule is a standalone git repo that can be independently developed, committed, and pushed.

## Prerequisites

- `git`, `uv`, `just` (no conda/venv activation needed — `uv` manages the venv automatically)

## Commands

All `just` commands work from anywhere under the devrepo root.

### Global (run from anywhere)

- `just start` — launch JupyterLab (`uv run jupyter lab`)
- `just install-all` — full install: `uv sync` + build all frontends + enable all extensions
- `just build-all` — build frontend assets in every submodule
- `just pull-all` — switch all submodules to `main` and pull
- `just sync` — run `uv sync` (rarely needed manually)
- `just clean` — remove `*.chat`, `*.ipynb` files from root
- `just reinstall-all` — delete venv and reinstall everything

### Local (run from within a submodule)

- `just build` — build frontend assets for current submodule
- `just pytest` — run pytest for current submodule
- `just lint` — run linters for current submodule
- `just reinstall` — re-install current submodule's Python package (needed after `pyproject.toml` changes)

## Development guide

- *After editing frontend files* in a submodule, run `just build` in that submodule, then refresh the browser.
- *After editing Python files*, restart the JupyterLab server. No build needed.
- *After editing `pyproject.toml`* in a submodule, run `just reinstall` in that submodule, then restart the server.
- *After editing `pyproject.toml`* at the devrepo root, run `just sync`.

## Architecture

### Submodule overview

- **jupyter-chat** — Chat UI framework (Yjs CRDT, React components). Special structure: Python package at `jupyter-chat/python/jupyterlab-chat/`, npm packages at `jupyter-chat/packages/`.
- **jupyter-ai-persona-manager** — Persona registry and message routing. Provides `BasePersona` and `PersonaManager`. Depends on jupyter-chat.
- **jupyter-ai-acp-client** — ACP protocol client for agent subprocesses. Provides `BaseAcpPersona` and `JaiAcpClient`. Depends on persona-manager.
- **jupyter-ai-jupyternaut** — LiteLLM-based persona. Depends on persona-manager.
- **jupyter-ai-claude-code** — Claude Code persona. Depends on persona-manager.
- **jupyter-ai-litellm** — LiteLLM provider integration.
- **jupyter-ai-router** — Routes messages to personas. Depends on persona-manager.
- **jupyter-ai-chat-commands** — Slash command infrastructure.
- **jupyterlab-commands-toolkit** — Command palette utilities.
- **jupyter-server-documents** — Server-side document access.

### Data flow

1. User sends message in browser → Yjs `YChat` syncs to server
2. `PersonaManager` routes to the appropriate persona based on @-mentions
3. Persona processes the message and writes its response back to `YChat`
4. Yjs syncs back to browser → React components re-render

## Code Style

- **TypeScript**: ESLint + Prettier. Single quotes, no trailing commas. Interfaces must start with `I` (e.g., `IToolCall`). CSS classes namespaced as `.jp-{package-name}-{component}`.
- **Python**: PEP 8, 4-space indent. Relative imports within packages (`from .foo import bar`).
- Version source of truth is `package.json` (synced to `pyproject.toml` via `hatch-nodejs-version`).
- Use `jlpm` for JS package management, never `npm` or `yarn` directly.

## Submodule CLAUDE.md Files

Some submodules have their own `CLAUDE.md` (often symlinked to `AGENTS.md`). Those contain submodule-specific details. This file covers the devrepo-level concerns.
