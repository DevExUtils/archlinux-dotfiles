#!/bin/zsh

# Sourcing applications / scripts into the shell environment

# Loads FZF keybindings, replacing native reverse search etc with FZF
[[ -e "/usr/share/fzf/key-bindings.zsh" ]] \
  && source "/usr/share/fzf/key-bindings.zsh"

# Load Zoxide
eval "$(zoxide init zsh --cmd j --no-aliases)"

# Setup mise to auto activate on CD into project folders
eval "$(mise activate zsh)"

# Use Starship prompt with znap eval cashing
eval "$(starship init zsh)"

## pip
znap function _pip_completion pip 'eval "$( pip completion --zsh )"'
compctl -K    _pip_completion pip

## pipx
znap function _python_argcomplete pipx  'eval "$( register-python-argcomplete pipx )"'
complete -o nospace -o default -o bashdefault \
           -F _python_argcomplete pipx
