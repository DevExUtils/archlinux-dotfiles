<h1 align="center">
    <a name="top" title="dotfiles">~/.&nbsp;📂</a><br/>Linux & macOS dotfiles<br/> <sup><sub>powered by  <a href="https://www.chezmoi.io/">chezmoi</a> 🏠</sub></sup>
</h1>

Use Chezmoi to bootstrap your development environment.  
Currently supports configuration and installation on:  

- [macOS Ventura][macOS] or later
- [ArchLinux][ArchLinux]

Content:

- [Setup](#setup)
  - [Prerequisites](#prerequisites)
  - [Installation 🚀](#installation-)
    - [Troubleshooting](#troubleshooting)
- [Template Variables ⚙️](#template-variables-️)
- [Supported toolset 🛠️](#supported-toolset-️)
  - [🐚 Shell](#-shell)
  - [🛠️ Developer Tools](#️-developer-tools)
  - [📦 Packages](#-packages)
  - [💻 PowerShell](#-powershell)


# Setup

## Prerequisites

- [Git][Git] for version-control system
- [Chezmoi][Chezmoi] for dotfile management

## Installation 🚀

When initializing the configuration, parameters in the [.chezmoi.toml](home/.chezmoi.toml.tmpl) file must be entered.
For this we have two options, interactive with you entering the values when prompted, and automated, feeding the data as command-line parameters.

If you apply the configuration manually, this can be done with the following commands: 

```bash
chezmoi init https://github.com/DevExUtils/archlinux-dotfiles
chezmoi apply
```
This will prompt you to enter:
* **email**: used for gitconfig
* **name**: used for gitconfig
* **work_device**: used to setup corporate certificates in zsh config

```bash
chezmoi init https://github.com/DevExUtils/archlinux-dotfiles.git \
--promptString "email"="$EMAIL" \
--promptString "name"="$NAME" \
--promptBool "work_device"="false" --apply
```


### Troubleshooting 

To inspect the rendered chezmoi configuration on your machine:

```bash
chezmoi cat-config
```

To preview what changes `chezmoi apply` would make without applying them:

```bash
chezmoi diff
```


# Template Variables ⚙️

Chezmoi prompts for the following variables at `chezmoi init` time. They are stored in `~/.config/chezmoi/chezmoi.toml` and injected into templated dotfiles.

| Variable | Type | Used In | Description |
|---|---|---|---|
| `email` | string | `~/.config/git/config` | Git commit author email |
| `name` | string | `~/.config/git/config` | Git commit author name |
| `work_device` | bool | `~/.config/zsh/settings/03-shell-env.zsh` | Injects corporate CA cert environment variables |

### 🏢 Work Device — Corporate CA Certificate

When `work_device` is set to `true`, the following environment variables are added to your shell:

```bash
NODE_EXTRA_CA_CERTS="/etc/ssl/certs/company-ca.pem"
AWS_CA_BUNDLE="/etc/ssl/certs/company-ca.pem"
```

> :warning: **You must bring your own company CA certificate.** The configuration only sets the environment variables — it does **not** install a certificate file. Place your company's CA bundle at `/etc/ssl/certs/company-ca.pem` (or update the path in the template to match your organization's setup).


# Supported toolset 🛠️

Use either one or many of these, the config files will be in place and ready to provide a familiar interface.

## 🐚 Shell

Zsh is configured with full **XDG Base Directory** compliance — all config lives at `~/.config/zsh/` instead of cluttering `~/` with dotfiles. The configuration is split into numbered, sequentially loaded files for modularity.

### 📜 History

- **100,000** saved entries, stored at `~/.local/share/zsh/history`
- Cross-session sharing (`SHARE_HISTORY`)
- Full deduplication (`HIST_IGNORE_ALL_DUPS`, `HIST_SAVE_NO_DUPS`)
- Timestamps recorded (`EXTENDED_HISTORY`)
- Commands prefixed with a space are excluded (`HIST_IGNORE_SPACE`)

### 🔌 Plugin Manager

[Znap][Znap] — a lightweight, fast Zsh plugin manager. Auto-installs itself on first shell launch into `~/.config/zsh/plugins/zsh-snap/`.

### 🧩 Plugins

| Plugin | Purpose |
|---|---|
| [`Aloxaf/fzf-tab`][fzf-tab] | FZF-powered tab completion |
| [`zsh-users/zsh-autosuggestions`][zsh-autosuggestions] | Fish-like inline command suggestions |
| [`zdharma-continuum/fast-syntax-highlighting`][fast-syntax-highlighting] | Real-time syntax highlighting |
| [`MichaelAquilina/zsh-you-should-use`][you-should-use] | Reminds you when an alias exists for a command you typed |
| [`MichaelAquilina/zsh-autoswitch-virtualenv`][autoswitch-virtualenv] | Auto-activates Python virtualenvs on `cd` |
| [`DevExUtils/aws-utils-zsh`][aws-utils-zsh] | AWS profile selector and utilities |
| [`Bhupesh-V/ugit`][ugit] | FZF-powered undo for git operations |
| [`wfxr/forgit`][forgit] | FZF-powered interactive git commands |
| [`reegnz/jq-zsh-plugin`][jq-zsh-plugin] | Interactive `jq` filter builder |

### ⌨️ Key Bindings

| Binding | Action |
|---|---|
| `Ctrl+R` | FZF history search (replaces default reverse-search) |
| `Alt+Q` | Park current command, run another, then restore |
| `Alt+V` | Inspect terminal key codes |

### 🔗 Aliases

| Alias | Command | Description |
|---|---|---|
| `cat` | `bat -p` | Syntax-highlighted output |
| `l` | `eza --long --header --all --sort type --git` | Enhanced file listing |
| `ls` | `eza --long --header --all --sort type --git --group` | Enhanced file listing with group |
| `j` | `__zoxide_zi` | Interactive zoxide directory jump |
| `pip` | `python -m pip` | Safe pip invocation |
| `wget` | `wget --hsts-file=~/.local/share/wget-hsts` | XDG-compliant wget |
| `cm` | `chezmoi` | Chezmoi shorthand |
| `cmr` | `chezmoi re-add` | Re-sync edited files back to dotfiles source |
| `cmj` | `cd $(chezmoi source-path) && cd ..` | Jump to dotfiles repository |
| `gcm` | `git commit --message` | Quick git commit |
| `tf` | `terraform` | Terraform shorthand |
| `tfa` | `terraform apply -auto-approve` | Auto-approve Terraform apply |
| `tfaa` | `terraform apply -auto-approve` | Auto-approve Terraform apply (alternate) |
| `k` | `kubectl` | Kubernetes shorthand |
| `c` | `code .` | Open VS Code in current directory |
| `exp` | `explorer.exe .` | Open Windows Explorer from WSL |

### 🧰 Functions

| Function | Description |
|---|---|
| `pi` | **FZF package install** — fuzzy-search all available `yay` packages with live preview, multi-select, then install selected packages |
| `pr` | **FZF package remove** — fuzzy-search installed packages, multi-select, then uninstall with `yay -Rns` |
| `ghp [-p\|--private] [-w\|--work]` | **GitHub CLI profile switcher** — `--private` sets `GH_CONFIG_DIR` to a secondary account profile, `--work` switches back to default, no args shows current auth status |
| `check-path [filter]` | **PATH inspector** — browse all `$PATH` entries interactively with FZF; pass an argument to filter to matching entries |

### 🌐 External Tool Integration

The shell sources and initializes the following tools:

- [**zoxide**][zoxide] — smart directory jumper, aliased to `j`
- [**mise**][mise] — auto-switches runtimes (Node/Python) per project
- [**Starship**][Starship] — cross-shell prompt (cached via `znap eval`)
- [**fzf**][fzf] — `Ctrl+R` history search via system key-bindings
- Lazy completions for `pip` and `pipx` via `znap function`


## 🛠️ Developer Tools

### Mise — Runtime Version Manager

- Manages **Node.js LTS** and **Python 3.11** globally
- Auto-switches versions per-project based on `.tool-versions`, `.nvmrc`, or `.python-version` files (`legacy_version_file = true`)
- 4 parallel install jobs
- Activated in the shell via `mise activate zsh`

### Starship — Shell Prompt

- Cross-shell prompt (Zsh + PowerShell)
- ⛵ Kubernetes context indicator
- Command duration display styled in Nord blue (`#88C0D0`)
- Shell indicator enabled (shows `pwsh` for PowerShell)

### Git

- **Diff pager**: [delta][delta] with syntax highlighting and `n`/`N` navigation between diff sections
- **Conflict style**: `diff3` (shows base, ours, and theirs)
- **Credentials**: `gh auth git-credential` for github.com and gist.github.com
- **Default branch**: `main`
- **Safe directory**: `*` (allows all directories)

### npm / pnpm

- npm prefix → `~/.local/share/npm`, cache → `~/.cache/npm` (XDG-compliant)
- `PNPM_HOME` → `~/.local/share/pnpm`, added to `PATH`


## 📦 Packages

Packages are automatically installed on `chezmoi apply` via `run_onchange` scripts. The install triggers whenever the package list in the script changes.

### 🐧 Arch Linux (via `yay`)

A full system update (`yay -Syu`) is performed before installing packages.

**Base Tools:**

`bat` `eza` `fd` `fzf` `git-delta` `github-cli` `jq` `powershell-bin` `procs` `reflector` `ripgrep` `rsync` `starship` `unzip` `wget` `wslu` `xdg-ninja-git` `zip` `zoxide`

**Cloud Tools:**

`aws-cli-v2` `azure-cli-bin` `terraform` `pulumi` `kubectl-bin`

**Developer Tools:**

`pnpm` `npm` `neovim` `onefetch` `mise` `python-pipx`

### 🍎 macOS (via Homebrew)

A `Brewfile` is generated and executed with `brew bundle`.

**Brews:**

`bat` `curl` `exa` `fd` `ffmpeg` `gh` `git` `go` `jq` `ripgrep` `wget`

**Casks:**

`google-chrome` `hammerspoon` `spotify` `visual-studio-code` `vlc`

### 🔧 Post-install Runtimes (both platforms)

Installed after packages are in place:

**Node.js (pnpm global):**

`typescript` `aws-cdk`

**Python (pipx):**

`poetry` `cfn-lint` `pre-commit` `aws-sso-util`


## 💻 PowerShell

A PowerShell profile is included for cross-platform parity. Modules are auto-installed on first launch if missing.

| Feature | Details |
|---|---|
| `PSFzf` module | `Ctrl+T` for FZF file search, `Ctrl+R` for FZF command history |
| `Terminal-Icons` module | File icons in directory listings |
| Starship prompt | Same cross-shell prompt as Zsh |
| Zoxide | Smart directory jump with `j` alias (interactive mode) |
| `ls` / `l` | Aliased to `eza` with long format, icons, hyperlinks, git info, and group |


[macOS]: https://www.apple.com/macos/ventura/
[ArchLinux]: https://archlinux.org/
[Git]: https://git-scm.com/
[Chezmoi]: https://www.chezmoi.io/install/
[Znap]: https://github.com/marlonrichert/zsh-snap
[fzf-tab]: https://github.com/Aloxaf/fzf-tab
[zsh-autosuggestions]: https://github.com/zsh-users/zsh-autosuggestions
[fast-syntax-highlighting]: https://github.com/zdharma-continuum/fast-syntax-highlighting
[you-should-use]: https://github.com/MichaelAquilina/zsh-you-should-use
[autoswitch-virtualenv]: https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv
[aws-utils-zsh]: https://github.com/DevExUtils/aws-utils-zsh
[ugit]: https://github.com/Bhupesh-V/ugit
[forgit]: https://github.com/wfxr/forgit
[jq-zsh-plugin]: https://github.com/reegnz/jq-zsh-plugin
[zoxide]: https://github.com/ajeetdsouza/zoxide
[mise]: https://mise.jdx.dev/
[Starship]: https://starship.rs/
[fzf]: https://github.com/junegunn/fzf
[delta]: https://github.com/dandavison/delta
