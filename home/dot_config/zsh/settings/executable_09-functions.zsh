#!/bin/zsh

# FZF Yay 
##  Search and install packages with fzf
pi() { 
	SELECTED_PKGS="$(yay -Slq | fzf --header='Install packages' -m --preview 'yay -Si {1}')"
	if [ -n "$SELECTED_PKGS" ]; then
		yay -S "$SELECTED_PKGS"
	fi
}

## Search and remove installed packages with fzf
pr() { 
	SELECTED_PKGS="$(yay -Qsq | fzf --header='Remove packages' -m --preview 'yay -Si {1}')"
	if [ -n "$SELECTED_PKGS" ]; then
		yay -Rns "$SELECTED_PKGS"
	fi
}

# Change Github CLI profile 
ghp() { 
  case ${1} in
      -p | --private)
          export GH_CONFIG_DIR="$HOME/.config/gh/private"
          ;;
      -w | --work)
	  	  unset GH_CONFIG_DIR
          ;;
      *)
	      gh auth status
		  ;;
  esac
}

# Helps quickly search in $PATH to validate if folder is available
check-path() { 
  if [[ "$#" -eq 0 ]]; then
    echo -e ${PATH//:/\\n} | fzf --header='Directories in PATH'
  elif [[ "$#" -eq 1 ]]; then
    echo -e ${PATH//:/\\n} | fzf -q ${1} --select-1 --exit-0 --header='Directories matching search word in PATH'
  fi
}

bootstrap-python() {
  if [ ! -f ./.python-version ]; then
    echo ".python-version file not found"
    echo "Select python version to install"
    exit 1
fi
}
