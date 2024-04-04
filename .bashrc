# Bash runtime configurations
case $- in
    *i*) ;;
    *) return;;
esac

DEPENDENCY_SERVICE=0
DEPENDENCY_GDRIVE=1
DEPENDENCY_THEMES=1
install-themes() {
    sudo curl -Lo /usr/bin/theme.sh 'https://git.io/JM70M' && sudo chmod +x /usr/bin/theme.sh
}
DEPENDENCY_ALACRITTYCOLOR=1
DEPENDENCY_NVIM=0

CODE_DIR="/mnt/gdrive/My\ Drive/code/"
if ! [[ -d $CODE_DIR ]]; then
    # if this doesn't work make sure DEPENDENCY_GDRIVE == 0
    CODE_DIR="~/Documents/"
fi

WINDOWS_USER="mecan"
export EDITOR="vim"

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
    prompt_color='\[\033[1;32m\]'
    if [ "$EUID" -eq 0 ]; then # Change prompt colors for root user
        prompt_color='\[\033[1;31m\]'
    fi

    PS1='${debian_chroot:+($debian_chroot)}'$prompt_color'[\u@\h]:\[\033[00m\]\n\[\033[01;34m\]\w\[\033[00m\]\$ '
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

install-insulter() {
    sudo wget -O /etc/bash.command-not-found https://raw.githubusercontent.com/hkbakke/bash-insulter/master/src/bash.command-not-found
}

if [ -f /etc/bash.command-not-found ]; then
    . /etc/bash.command-not-found
fi

export GEM_HOME="/usr/share/gems"
# . "$HOME/.cargo/env"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="/usr/share/gems/bin:$PATH"

dependency-error() {
    echo "If this error bothers you, consider setting the DEPENDENCY_$1 flag at the top of this file to '0'"
}

if ((DEPENDENCY_SERVICE)); then
    if [[ $(service ssh status | grep "not") ]]; then
        echo "starting ssh server"
        sudo service ssh start
	# sudo systemctl start sshd.service
    fi
fi

install-tt() {
	sudo curl -L https://github.com/lemnos/tt/releases/download/v0.4.2/tt-linux -o /usr/local/bin/tt && sudo chmod +x /usr/local/bin/tt
}

install-glow() {
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt update && sudo apt install glow
}

install-bashrc() {
	git clone https://github.com/mecaneer23/.bashrc temp.bashrc;
	for i in $(ls temp.bashrc); do
		mv ~/$i ~/$i.old;
	done;
	mv temp.bashrc/* ~/
	mv temp.bashrc/.* ~/
	rm -rf temp.bashrc;
	source ~/.bashrc
}

fix-run-detectors-error() {
    sudo update-binfmts --disable cli
}

reset-time() {
    # sudo hwclock -s
    echo resetting time...
    sudo ntpdate time.windows.com
}
reset-time

nf() {
    if [[ ! $1 ]]; then
        neofetch --ascii_distro arch
    else 
        neofetch --ascii_distro $1
    fi
}

set-resolution() {
    if [[ $1 == "-h" ]]; then
        echo "set-resolution 1920 1080 60"
        return
    fi
    if [[ -z "$@" ]]; then
        echo "An argument is needed to run this script";
        return
    else
        arg="$@"
        if [[ $(($(echo $arg | grep -o "\s" | wc --chars) / 2 )) -ne 2 ]]; then
            echo "Invalid Parameters. You need to specify parameters in the format \"width height refreshRate\""
            echo "For example setResolution \"1920 1080 60\""
            return
        fi
        modename=$(echo $arg | sed 's/\s/_/g')
        display=$(xrandr | grep -Po '.+(?=\sconnected)')
        if [[ "$(xrandr|grep $modename)" = "" ]]; then
            xrandr --newmode $modename $(gtf $(echo $arg) | grep -oP '(?<="\s\s).+') &&
            xrandr --addmode $display $modename     
        fi
        xrandr --output $display --mode $modename

        if [[ $? -eq 0 ]]; then
            echo "Display changed successfully to $arg"
        fi
    fi
    gtf 1920 1080 60
    xrandr --newmode "1920x1080_60.00"  172.80  1920 2040 2248 2576  1080 1081 1084 1118  -HSync +Vsync
    xrandr --addmode VGA1 "1920x1080_60.00"
    xrandr --output VGA1 --mode "1920x1080_60.00"
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
        *.tar.lz)
            lzip -d -k $1
            tar xf ${1%.lz}
            rm -f ${1%.lz}
            ;;
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
    elif [ "$1" = "clone" ]; then
        shift
        command sudo git clone https://github.com/mecaneer23/"$@"
    else
        command sudo "$@"
    fi
}

run-from-drive() {
    directory=$CODE_DIR
    case "$1" in
        "bin-snake")
            sub="programming-languages/bin-snake/bin_snake.py" ;;
        "snake")
            sub="games/snake/python-snake-game/snake.py" ;;
        "binary-decimal")
            sub="binary-decimal/BinarytoDecimal.py" ;;
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
        "view-colors")
            sub="alacritty-color/view-colors.py" ;;
        "alacritty-color")
            sub="alacritty-color/alacritty-color" ;;
		"snake-case")
			sub="to-snake-case/snake_case.py" ;;
        "settings")
            sub="simple-settings/tkmenu.py" ;;
	"waiwo")
	    sub="what-am-i-working-on/generate.py" ;;
        "help")
            type run-from-drive 
            return
            ;;
        *)
            echo "Error: $@ not implemented in run-from-drive function"
            return
            ;;
    esac
    shift
    if [ $(python3 -c 'exec("""\nimport sys;from pathlib import Path\nprint(Path(" ".join(sys.argv[1:]).replace("\ ", " ")).expanduser().is_file())""")' $directory$sub) == "True" ]; then
        eval $directory$sub "$@"
    else
        echo "Error: Try running 'clone $(echo $sub | cut -d "/" -f 1)'"
    fi
}

mnt() {
    cd /mnt/$1
}

qemu() {
    read -p "Path to file: " path
    read -p "Memory in MB (2048, etc): " mem 
    sudo qemu-system-x86_64 -enable-kvm -cdrom path -m mem -sdl
}

serve() {
    (python3 -m http.server &)
    (python3 -c "import webbrowser; webbrowser.open('localhost:8000')" &)
}

db() {
    echo 
    case "${1##*.}" in
        "py")
            python3 -m pdb $@ ;;
        *)
            gdb $@ ;;
    esac
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

mount-gdrive() {
    if [ $1 == "g" ]; then
        sudo mount -t drvfs G: /mnt/gdrive
    elif [ $1 == "h" ]; then
        sudo mount -t drvfs H: /mnt/gdrive
    fi
}

if ((DEPENDENCY_GDRIVE)); then
    if [ ! "$(ls -A /mnt/gdrive)" ]; then
        echo "mounting gdrive"
        mount-gdrive g || dependency-error GDRIVE
        #if [ "$out" ]; then
        #   sudo umount /mnt/gdrive
        #   sudo mount -t drvfs H: /mnt/gdrive
        #fi
    fi
    CODE_DIR="/mnt/gdrive/My\ Drive/code/"
fi

alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias l.="ls -A | grep -E '^\.'"

alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

alias lc=lolcat
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'
alias cs=cowsay
alias cmx=cmatrix
# alias bat=batcat
alias sr="set-resolution 1920 1080 60"

alias apti="sudo apt install"
alias aptu="sudo apt update"
alias paci="sudo pacman -S"

vim() {
    if [ -d "$1" ]; then
        command vim $@;
    elif ((DEPENDENCY_NVIM)); then
        nvim $@;
    else
        command vim $@
    fi
}

alias rc="vim ~/.bashrc && source ~/.bashrc"
alias vimrc="vim /home/$USER/.vimrc"

if ((DEPENDENCY_ALACRITTYCOLOR)); then
    AC_COMMAND="run-from-drive alacritty-color"
    alias ac="$AC_COMMAND"
    alias acc="$AC_COMMAND --current"
    alias acr="$AC_COMMAND --random"
    acl() {
    if [[ ! $1 ]]; then
        $AC_COMMAND --list
    else
        $AC_COMMAND --list | grep $1
    fi
    }
fi

if ((DEPENDENCY_THEMES)); then
    theme.sh kimber || dependency-error THEMES
    #        spacedust
    #        nova
    alias ac="vim + /mnt/c/Users/$WINDOWS_USER/AppData/Roaming/alacritty/alacritty.yml"
fi

alias celar=clear

alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gs="git status"
alias gd="git diff"
alias gl="git log"
clone() {
    git clone https://github.com/mecaneer23/$1 $2
}

alias sps=set-prompt-short
alias spd=set-prompt-dollar
alias spc=set-prompt-color

alias c="cd /mnt/c/Users/$WINDOWS_USER/OneDrive/Documents/"
alias g="cd $CODE_DIR"
alias f="cd $CODE_DIR/../files"
alias d="cd /mnt/c/Users/$WINDOWS_USER/Downloads/"

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
alias ipy=ipython3
alias pdb="python3 -m pdb"

alias bs="run-from-drive bin-snake $@"
alias snake="run-from-drive snake $@"
alias btd="run-from-drive binary-decimal $@"
alias sl="run-from-drive sl $@"
alias becho="run-from-drive becho $@"
alias clock="run-from-drive clock $@"
alias wordle="run-from-drive wordle $@"
alias hc="run-from-drive HackerCode $@"
alias todo="run-from-drive todo $@"
alias vc="run-from-drive view-colors $@"
alias sc="run-from-drive snake-case $@"
alias settings="run-from-drive settings $@"

if ((DEPENDENCY_GDRIVE)); then
    alias code="powershell.exe -c 'code .' &"
    alias cmd="powershell.exe"
    alias waiwo="cmd python '\"G:\My Drive\code\what-am-i-working-on\generate.py\"' $@"
else
    alias waiwo="run-from-drive waiwo $@"
fi

