# Bash runtime configurations
case $- in
    *i*) ;;
    *) return;;
esac

DEPENDENCIES=1
ALACRITTYCOLOR=0

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\][\u@\h]:\[\033[00m\]\n\[\033[01;34m\]\w\[\033[00m\]\$ '
else
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if ! shopt -oq posix; then
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
fi
# . "$HOME/.cargo/env"
export PATH="$PATH:$HOME/.cargo/bin"

if ((DEPENDENCIES)); then
    if [[ $(service ssh status | grep "not") ]]; then
        sudo service ssh start
    fi
fi

set_time() {
    # sudo hwclock -s
    sudo ntpdate time.windows.com
}

nf() {
    if [[ ! $1 ]]; then
    neofetch --ascii_distro arch
    else 
    neofetch --ascii_distro $1
    fi
}

clearls() {
    clear
    ls --color=auto
}

set_prompt() {
    export PS1=$1
    echo "https://phoenixnap.com/kb/change-bash-prompt-linux"
}

set-prompt-dollar() {
    export PS1="\[\033[1;32m\]$\[\033[0m\] "
}

set-prompt-short() {
    export PS1="\[\033[1;32m\][\[\033[1;34m\]\W\[\033[1;32m\]]\[\033[0m\]\$ "
}

set-prompt-color() {
    export PS1='#\[\033[30m\]#\[\033[31m\]#\[\033[32m\]#\[\033[33m\]#\[\033[34m\]#\[\033[35m\]#\[\033[36m\]#
\[\033[37m\]#\[\033[1;30m\]#\[\033[1;31m\]#\[\033[1;32m\]#\[\033[1;33m\]#\[\033[1;34m\]#\[\033[1;35m\]#\[\033[1;36m\]#\[\033[1;37m\]#\[\033[0m\]
\[\033[1;32m\][\[\033[1;34m\]\W\[\033[1;32m\]]\[\033[0m\]\$ '
}

ex() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   tar xf $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

git() {
    # if [ "$1" = "push" ]; then
    # shift
    # powershell.exe -c git push
    # elif
    if [ "$1" = "statsu" ]; then
        git status
    else 
        command git "$@"
    fi
}

sudo() {
    if [ "$1" = "apt" ]; then
        shift
        if [ "$1" = "update" ]; then
            command sudo apt update || (reset-time && sudo apt update)
        else
            command sudo apt "$@"
        fi
    else
        command sudo "$@"
    fi
}

run-from-drive() {
    directory="/mnt/gdrive/My\ Drive/code/"
    case "$1" in
        "bin-snake")
            sub="programming-languages/bin-snake/bin_snake.py" ;;
        "snake")
            sub="snake/python-snake-game/snake.py" ;;
        "sl")
            sub="sl/sl.py" ;;
        "becho")
            sub="becho/becho" ;;
        "clock")
            sub="clock/ascii/clock.py" ;;
        "wordle")
            sub="wordle/solver.py" ;;
        "HackerCode")
            sub="hackercode/hackercode/HackerCode.py" ;;
        "todo")
            sub="todo/todo.py" ;;
        "help")
            type run-from-drive 
            return
            ;;
        *)
            echo "$@ not implemented in run-from-drive function"
            return
            ;;
    esac
    shift
    eval $directory$sub "$@"
}

mnt() {
    cd /mnt/$1
}

serve() {
    (python3 -m http.server &)
    (python3 -c "import webbrowser; webbrowser.open('localhost:8000')" &)
}

export XLAUNCH_DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
export DEFAULT_DISPLAY=$DISPLAY;

display-swap() {
    if [[ $DISPLAY == $DEFAULT_DISPLAY ]]; then
    export DISPLAY=$XLAUNCH_DISPLAY;
    elif [[ $DISPLAY == $XLAUNCH_DISPLAY ]]; then
    export DISPLAY=$DEFAULT_DISPLAY;
    fi;
    echo $DISPLAY;
}

# acl() {
#   if [[ ! $1 ]]; then
#     alacritty-color --list
#   else
#     alacritty-color --list | grep $1
#   fi
# }

mount-gdrive() {
    if [ $1 == "g" ]; then
        sudo mount -t drvfs G: /mnt/gdrive
    elif [ $1 == "h" ]; then
        sudo mount -t drvfs H: /mnt/gdrive
    fi
}

if ((DEPENDENCIES)); then
    if [ ! "$(ls -A /mnt/gdrive)" ]; then
        mount-gdrive g || echo "If this error bothers you, consider setting the DEPENDENCIES flag at the top of this file to '0'"
        #if [ "$out" ]; then
        #   sudo umount /mnt/gdrive
        #   sudo mount -t drvfs H: /mnt/gdrive
        #fi
    fi
fi

alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias l.="ls -A | grep -E '^\.'"

alias lc=lolcat
alias cmx=cmatrix
alias batcat=bat

alias rc="vim ~/.bashrc && source ~/.bashrc"
alias vimrc="vim /home/mecaneer23/.vimrc"
alias ac="vim + /mnt/c/Users/mecan/AppData/Roaming/alacritty/alacritty.yml"

if ((DEPENDENCIES)); then
    if ((ALACRITTYCOLOR)); then
	alias ac="alacritty-color"
	alias acc="alacritty-color --current"
	alias acr="alacritty-color --random"
    else
	theme.sh kimber # spacedust
    fi
fi

alias celar=clear

alias ga="git add"
alias gc="git commit -m"
alias gph="git push"
alias gp="git push"
alias gpl="git pull"
alias gs="git status"
alias gd="git diff"
clone() {
    git clone https://github.com/mecaneer23/$1
}

alias sps=set-prompt-short
alias spd=set-prompt-dollar
alias spc=set-prompt-color
alias reset-time=set_time

alias c="cd /mnt/c/Users/mecan/OneDrive/Documents/"
alias g="cd /mnt/gdrive/My\ Drive/code/"
alias d="cd /mnt/c/Users/mecan/Downloads/"

alias ..="cd .."
alias ...="cd ../.."
alias .2="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias .5="cd ../../../../.."

# alias ssh-live="ssh peppermint@192.168.1.233"
# alias ssh-family='ssh mecaneer23@192.168.1.184'
# alias mv-porth-to-linux-pc="rsync /mnt/gdrive/My\ Drive/Code/binary_decimal/not_done/BinarytoDecimal.porth peppermint@192.168.1.233:~/ && ssh-live"
alias ssh-home="ssh mecaneer23@ssh.mecaneer23.net"

alias py=python3
alias py310="python3.10"
alias ipy=ipython

alias bs="run-from-drive bin-snake $@"
alias snake="run-from-drive snake $@"
alias sl="run-from-drive sl $@"
alias becho="run-from-drive becho $@"
alias clock="run-from-drive clock $@"
alias wordle="run-from-drive wordle $@"
alias hc="run-from-drive HackerCode $@"
alias todo="run-from-drive todo $@"

alias code="powershell.exe -c code ."
alias cmd="powershell.exe"
