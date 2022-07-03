# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

path+=('/usr/bin')
path+=('/home/bevis/bin')
path+=('/home/bevis/.emacs.d/bin')
export PATH
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim
export SHELL=/usr/bin/zsh
export GOPATH=/home/bevis/Playground/go

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/bevis/.zshrc'

autoload -Uz compinit
compinit

setopt extendedglob

# dynamic title
case ${TERM} in
	 alacritty*)
		 local term_title () { print -n "\e]0;${(j: :q)@}\a" }
   		 precmd () {
     			 local DIR="$(print -P '  %~')"
     			 term_title "$DIR" " zsh"
   			 }
   		 preexec () {
     			 local DIR="$(print -P '  %~')"
			 local ICN="$(print -P '')"
     			 local CMD="${(j:\n:)${(f)1}}"
     			 term_title "$DIR" "$ICN" "$CMD"
   		 }
	         ;;
esac

# case-insensitive (all) completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# End of lines added by compinstall
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zsh auto suggestions and syntax highlighting and auto completion
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="false"

# fzf source
source /usr/share/fzf/key-bindings.zsh

# autocomplete source
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

#nvm source
source /usr/share/nvm/init-nvm.sh


###############################
# ****** ALIAS SECTION ****** #
###############################
#special aliass
#
alias http='noglob http'

# alias for sourcing the zshrc
alias sr='source ~/.zshrc'
# alias for cd up a directory
alias ..="cd .."
# alias for going to a .config file, used exclusivly to navigate dotfiles files inside .dotfiles
alias cdc='cd .config'
# alias for making a directory and cd to it
mcd () {
    mkdir -p $1
    cd $1
}
# alias for searching through ps
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e" 
# alias for mkdir so that it makes required parent directory
alias mkdir="mkdir -p"
# alias for exa
alias ls='exa --icons'
alias lst='exa --icons -T'
alias lsa='exa -a --icons'
alias lsat='exa -a --icons -T'
alias lls='exa -l --changed --git --icons'
alias llsa='exa -l -a --changed --git --icons'
# alias for ranger
alias fm='ranger'
# alias for searching and installing packages
alias pacs="pacman -Slq | fzf -m --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk \"{print \$2}\")' | xargs -ro sudo pacman -S"
# alias for searching and installing packages from AUR
alias yays="yay -Slq | fzf -m --preview 'cat <(yay -Si {1}) <(yay -Fl {1} | awk \"{print \$2}\")' | xargs -ro  yay -S"
# alias for searching and removing packages from system
alias pacr="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"
# alias for searching packages from system
alias pac="pacman -Q | fzf"
# alias for wifi
alias wifi="nmtui-connect"
# alias for grep
alias grep='grep --color=auto'
# alias for Neovim
alias vim='nvim'
# alias for verbose cp, mv, rm
alias mv='mv -v'
alias cp='cp -vr'
alias rm='rm -vr'
# alias for running cpp files
rc(){
  g++ "$1" -o run
  ./run
}
# alias for managing dotfiles with git bare
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
# alias for checking dunst
alias dun='killall dunst && dunst &
notify-send "cool1" "yeah it is working"
notify-send "cool2" "yeah it is working"'

#Development Aliases
export LOCAL_IP=`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'`
alias serve="browser-sync start -s -f . --no-notify --host $LOCAL_IP --port 9000"
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
