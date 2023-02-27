# Bash runtime configurations
case $- in
    *i*) ;;
    *) return;;
esac
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
if [ ! "$(ls -A /mnt/gdrive)" ]; then
    sudo mount -t drvfs G: /mnt/gdrive
fi

if [[ $(service ssh status | grep "not") ]]; then
    sudo service ssh start
fi
theme.sh kimber # spacedust

set_time() {
    # sudo hwclock -s
    sudo ntpdate time.windows.com
}

set_prompt() {
    export PS1=$1
    echo "https://phoenixnap.com/kb/change-bash-prompt-linux"
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

set_dollar_sign() {
    export PS1="$ "
}

set_prompt_short() {
    export PS1="[\W]\$ "
}

git() {
    # if [ "$1" = "push" ]; then
    # shift
    # powershell.exe -c git push
    # el
    if [ "$1" = "statsu" ]; then
        git status
    else 
        command git "$@"
    fi
}

run-from-drive() {
    directory="/mnt/gdrive/My\ Drive/code/"
    if [ "$1" = "bin-snake" ]; then
        sub="programming-languages/bin-snake/bin_snake.py"
    elif [ "$1" = "snake" ]; then
        sub="snake/python-snake-game/snake.py"
    elif [ "$1" = "sl" ]; then
        sub="sl/sl.py"
    elif [ "$1" = "becho" ]; then
        sub="becho/becho"
    elif [ "$1" = "clock" ]; then
        sub="clock/ascii/clock.py"
    elif [ "$1" = "wordle" ]; then
        sub="wordle/solver.py"
    fi
    eval $directory$sub
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

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias hc=HackerCode
alias lc=lolcat
alias cmx=cmatrix
alias batcat=bat

alias rc="vim /home/mecaneer23/.bashrc && source /home/mecaneer23/.bashrc"
alias vimrc="vim /home/mecaneer23/.vimrc"
alias ac="vim + /mnt/c/Users/mecan/AppData/Roaming/alacritty/alacritty.yml"

# alias ac="alacritty-color"
# alias acc="alacritty-color --current"
# alias acr="alacritty-color --random"

alias celar=clear

alias sps=set_prompt_short
alias reset-time=set_time

alias c="cd /mnt/c/Users/mecan/OneDrive/Documents/"
alias g="cd /mnt/gdrive/My\ Drive/code/"
alias d="cd /mnt/c/Users/mecan/Downloads/"

alias ..="cd .."
alias .2="cd ../.."
alias ...="cd ../.."
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

alias bs="run-from-drive bin-snake"
alias snake="run-from-drive snake"
alias sl="run-from-drive sl"
alias becho="run-from-drive becho"
alias clock="run-from-drive clock"
alias wordle="run-from-drive wordle"

alias code="powershell.exe -c code ."
alias cmd="powershell.exe"
