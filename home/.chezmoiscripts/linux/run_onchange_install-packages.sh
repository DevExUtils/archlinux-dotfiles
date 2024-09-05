#!/bin/zsh

declare -a BASE_TOOLS
BASE_TOOLS=(
    "bat"
    "eza"
    "fd"
    "fzf"
    "git-delta"
    "github-cli"
    "jq"
    "powershell-bin"
    "procs"
    "reflector"
    "ripgrep"
    "rsync"
    "starship"
    "unzip"
    "wget"
    "wslu"
    "xdg-ninja-git"
    "zip"
    "zoxide"
)

declare -a CLOUD_TOOLS
CLOUD_TOOLS=(
    "aws-cli-v2"
    "azure-cli-bin"
    "terraform"
    "pulumi"
    "kubectl-bin"
)

declare -a DEVELOPER_TOOLS
DEVELOPER_TOOLS=(
    "pnpm"
    "npm"
    "neovim"
    "onefetch"
    "mise"
    "python-pipx"
)

PACKAGES=("${BASE_TOOLS[@]}" "${CLOUD_TOOLS[@]}" "${DEVELOPER_TOOLS[@]}")

yay -Syu --noprogressbar --noconfirm && \
yay --noconfirm --needed -S "${PACKAGES[@]}"
