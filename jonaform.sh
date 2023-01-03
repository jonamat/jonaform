#!/bin/bash

PUBKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAZ4UypCnbKr3wTCcAXNehMKVZcTMN56Fk1XktC1vKyO jonathan@all"
BASHRC=$(
    cat <<-END
alias rm="trash"
alias ll="ls -lha"
#alias la='ls -A'
#alias l='ls -CF'
alias "cd.."="cd .." 
alias ports="netstat -ltnp"
alias gt="gotop -l minimal"
alias dps='docker ps --all --format "table {{.Image}}\t{{.ID}}\t{{.State}}" | grep running'
alias dex="docker exec -ti "
alias up="docker-compose up"
alias down="docker-compose down"
alias python2="python2.7"
alias python="python3"
alias pip="pip3"
alias pip2="pip2.7"
alias sl="sqlite3"


alias targz="tar -xzvf"
alias tartar="tar -xvf"
alias tarbz2="tar -xjvf"
alias tarxz="tar -xJvf"
alias tarzip="unzip"
alias tar7z="tar -x7zvf"

# Enable incremental history search with up/down arrows (also Readline goodness)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'


# If not running interactively, don't do anything
case \$- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "\$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "\${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=\$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "\$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "\$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "\$color_prompt" = yes ]; then
    PS1='\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$ '
else
    PS1='\${debian_chroot:+(\$debian_chroot)}\u@\h:\w$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "\$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\${debian_chroot:+(\$debian_chroot)}\u@\h: \w\a\]\$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "\$(dircolors -b ~/.dircolors)" || eval "\$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'



# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# export PYENV_ROOT="\$HOME/.pyenv"
# command -v pyenv >/dev/null || export PATH="\$PYENV_ROOT/bin:\$PATH"
# eval "$\(pyenv init -)"


export PYENV_ROOT="\$HOME/.pyenv"
export PATH="\$PYENV_ROOT/bin:\$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
 eval "\$(pyenv init -)"
fi

export PATH="/usr/local/go/bin:\$PATH"
export PATH="/home/jonathan/go/bin:\$PATH"
export PATH="/home/jonathan/.local/bin:\$PATH"

DOCKER_BUILDKIT=1
END
)

if [ $USER != "jonathan" ];
  then echo "Only jonathan can use this script!"
  exit
fi

DOCKER=0
while true; do
    read -p "Do you need Docker and docker-compose? [y/n] " yn
    case $yn in
    [Yy]*)
        DOCKER=1
        break
        ;;
    [Nn]*) break ;;
    *) echo "Please answer y or n" ;;
    esac
done

GOLANG=0
while true; do
    read -p "Do you need Go? [y/n] " yn
    case $yn in
    [Yy]*)
        GOLANG=1
        break
        ;;
    [Nn]*) break ;;
    *) echo "Please answer y or n" ;;
    esac
done

MICRO=0
while true; do
    read -p "Do you need Micro? [y/n] " yn
    case $yn in
    [Yy]*)
        MICRO=1
        break
        ;;
    [Nn]*) break ;;
    *) echo "Please answer y or n" ;;
    esac
done

PYTHON3=0
while true; do
    read -p "Do you need Python3, pip3 and pyenv? [y/n] " yn
    case $yn in
    [Yy]*)
        PYTHON3=1
        break
        ;;
    [Nn]*) break ;;
    *) echo "Please answer y or n" ;;
    esac
done

NODEJS=0
while true; do
    read -p "Do you need NodeJS, npm and yarn? [y/n] " yn
    case $yn in
    [Yy]*)
        NODEJS=1
        break
        ;;
    [Nn]*) break ;;
    *) echo "Please answer y or n" ;;
    esac
done


SWAP=0
while true; do
    read -p "Do you want create a swapfile? [y/n] " yn
    case $yn in
    [Yy]*)
        SWAP=1
        break
        ;;
    [Nn]*) break ;;
    *) echo "Please answer y or n" ;;
    esac
done

if [ $SWAP -eq 1 ]; then
    read -p "How many GB do you want for swap? " SWAPSIZE
fi

sudo apt update
echo "Installing essentials..."
sudo apt install -y curl git vim tree sshfs nmap trash-cli build-essential procps file
echo "Done"

if [ $MICRO -eq 1 ]; then
    echo "Installing Micro..."
    curl https://getmic.ro | bash
    sudo mv micro /bin/micro
    echo "Done"
fi

if [ $DOCKER -eq 1 ]; then
    echo "Installing Docker..."
    sudo apt-get remove docker docker-engine docker.io containerd runc
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh ./get-docker.sh
    sudo apt-get install docker-compose-plugin
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
    sudo systemctl start docker
    rm get-docker.sh
    echo "Done"
fi

if [ $GOLANG -eq 1 ]; then
    echo "Installing Go..."
    sudo rm -rf /usr/local/go /tmp/gotop
    curl https://dl.google.com/go/go1.19.4.linux-amd64.tar.gz -o go1.19.4.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.19.4.linux-amd64.tar.gz
    rm go1.19.4.linux-amd64.tar.gz
    echo "Done"
fi

if [ $PYTHON3 -eq 1 ]; then
    echo "Installing Python..."
    sudo apt install -y python3 python3-pip
    sudo pip3 install --upgrade pip
    curl https://pyenv.run | bash
    echo "Done"
fi

if [ $NODEJS -eq 1 ]; then
    echo "Installing Node..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm install node
    nvm use default
    npm install -g yarn npm-check-updates
    echo "Done"
fi

if [ $SWAP -eq 1 ]; then
    echo "Creating swapfile..."
    sudo fallocate -l ${SWAPSIZE}G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo "Done"
fi

echo "Installing gotop..."
git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop
/tmp/gotop/scripts/download.sh
echo "Done"

echo "Authorizing ssh key"
mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
echo $PUBKEY >~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
echo "Done"

echo "Updating .bashrc"
touch ~/.bashrc
echo "$BASHRC" >~/.bashrc
source ~/.bashrc
echo "Done"

echo "The system was successfully Jonaformed!"
