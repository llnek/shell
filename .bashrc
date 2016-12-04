# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

userid=`whoami`

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#-------------------------------------------------------------
# Automatic setting of $DISPLAY (if not set already).
# This works for linux - your mileage may vary. ... 
# The problem is that different types of terminals give
# different answers to 'who am i' (rxvt in particular can be
# troublesome).
# I have not found a 'universal' method yet.
#-------------------------------------------------------------
 
function get_xserver ()
{
    case $TERM in
       xterm )
            XSERVER=$(who am i | awk '{print $NF}' | tr -d ')''(' ) 
            # Ane-Pieter Wieringa suggests the following alternative:
            # I_AM=$(who am i)
            # SERVER=${I_AM#*(}
            # SERVER=${SERVER%*)}
            XSERVER=${XSERVER%%:*}
            ;;
        aterm | rxvt)
        # Find some code that works here. ...
            ;;
    esac  
}

function showip ()
{
  echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo "++                                                                   ++"
  ifconfig -a | grep inet | sed -e 's/^[ \t]*//'
  echo "++                                                                   ++"
  echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
}

if [ -z ${DISPLAY:=""} ]; then
    get_xserver
    if [[ -z ${XSERVER}  || ${XSERVER} == $(hostname) || \
      ${XSERVER} == "unix" ]]; then 
        DISPLAY=":0.0"          # Display on local host.
    else
        DISPLAY=${XSERVER}:0.0  # Display on remote host.
    fi
fi
 
export DISPLAY
 

#### for visual studio code - OSX
###code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

#---------------------------
# Environment variables
#---------------------------
BOLD=$(tput smso)                         # turn on bold
GREENF=$(tput setaf 2)                    # green foreground
LIGHT_REDF=$(tput setaf 1 ; tput bold )   # light red foreground
NORM=$(tput sgr0)                         # reset to normal display
YELLOWF=$(tput setaf 3)                   # yellow foreground
LOCATION=Desktop                          # used by personal scripts
LOG=~/etc/log.txt                         # my log file
OS=$(uname -s)                            # "SunOS" or "Linux"
export LOCATION OS LOG

if [[ "${DISPLAY%%:0*}" != "" ]]; then  
    HILIT=${red}   # remote machine: prompt will be partly red
else
    HILIT=${cyan}  # local machine: prompt will be partly cyan
fi

function fastprompt()
{
    unset PROMPT_COMMAND
    case $TERM in
        *term | rxvt )
            PS1="${HILIT}[\h]$NC \W > \[\033]0;\${TERM} [\u@\h] \w\007\]" ;;
        linux )
            PS1="${HILIT}[\h]$NC \W > " ;;
        *)
            PS1="[\h] \W > " ;;
    esac
}
 
#fastprompt

#---------------------------
# Bash options
#---------------------------
set ulimit -c 0       # turn off core dumps
set bashhistfile=1000 # number of history file entries
set autolist          # auto list possibilities after ambiguous completion
set dunique           # removes duplicate entries in the dirstack
set histdup=prev      # do not allow consecutive duplicate history entries
#set noclobber        # output redirection will not overwrite an existing file
set notify            # notifies when a job completes
set symlinks=ignore   # treats symbolic directories like real directories
set time=5            # proc that run longer than $time seconds will be timed.
complete -A hostname   rsh rcp telnet rlogin r ftp ping disk
complete -A command    nohup exec eval trace gdb
complete -A command    command type which
complete -A export     printenv
complete -A variable   export local readonly unset
complete -A enabled    builtin
complete -A alias      alias unalias
complete -A function   function
complete -A user       su mail finger
complete -A directory  mkdir rmdir
complete -A directory   -o default cd
complete -f -d -X '*.gz'  gzip
complete -f -d -X '*.bz2' bzip2
complete -f -o default -X '!*.gz'  gunzip
complete -f -o default -X '!*.bz2' bunzip2
complete -f -o default -X '!*.pl'  perl perl5
complete -f -o default -X '!*.ps'  gs ghostview ps2pdf ps2ascii
complete -f -o default -X '!*.dvi' dvips dvipdf xdvi dviselect dvitype
complete -f -o default -X '!*.pdf' acroread pdf2ps
complete -f -o default -X '!*.texi*' makeinfo texi2dvi texi2html texi2pdf
complete -f -o default -X '!*.tex' tex latex slitex
complete -f -o default -X '!*.lyx' lyx
complete -f -o default -X '!*.+(jpg|gif|xpm|png|bmp)' xv gimp
complete -f -o default -X '!*.mp3' vlc
complete -f -o default -X '!*.ogg' vlc

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
#---------------------------
# Personal aliases
#---------------------------
alias top='top -o cpu'
alias h='history'                          # displays command history
alias j='jobs -l'                          # displays background jobs
alias ..='cd ..'                           # drops back one level
alias du='du -sh'                          # include sub-directories and make readable
alias df='df -h'                           # better format
#alias diff='vimdiff'                       # vimdiff color codes
alias less='vim -u /usr/share/vim/vim72/macros/less.vim'  # colorizes
alias tree='tree -Cs'                      # Linux only, but nice
alias pw='vim ~/etc/pw.txt'                # Password manager
#alias sol='klondike-1.2.pl'                # Life without fun?
#alias path="echo $PATH | tr ':' '\n'"      # displays current PATH 1 line per dir
alias s='cmatrix -b'                       # shell screen saver
#alias class='vi ~/etc/classes.txt ~/etc/schedule.txt' # Keeps me organized
#alias gbd='sftp bearded-dragon@bearded-dragon.strongspace.com' # secure storage on the net
# >>>> application starters <<<<
#alias centos="VBoxManage startvm 'CentOS'"
#alias sol10="VBoxManage startvm 'Solaris 10'"
#alias xp="VBoxManage startvm 'Windows XP'"
#alias im="nohup pidgin >/dev/null 2>&1 &"
#alias web="nohup firefox >/dev/null 2>&1 &"
#alias tv="nohup miro >/dev/null 2>&1 &"
#alias tunes="nohup rhythmbox-client --hide --play >/dev/null 2>&1 &"
#alias bt="nohup transmission >/dev/null 2>&1 &"
#alias fm="nautilus ~/downloads"
#if [ "$OS" == "Linux" ]
#then
#alias ls='ls -hF --color'  # only works with GNU version
alias ls='ls -hF '  # only works with GNU version
#alias grep='grep --color'  # only works with GNU version
#alias c='cd;clear;quote'   # my little quote system
#fi
#alias xt="xtitle `pwd`"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias ll='ls -lah'
alias gis='git status'


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#---------------------------
# Functions
#---------------------------

cfc() {
  coffee -b -o . -c *.coffee
}

log(){ ## log entry tool
    if [ $# == 0 ] # display todays entry's
    then
        grep $(date '+%D') $LOG
    else
        # make an entry
        echo "$(date '+%D %T') $HOSTNAME [$$] $*">>$LOG
        echo "${GREENF}$(date '+%D %T')${NORM} $HOSTNAME ${YELLOWF}[$$]${NORM} $*"
    fi
}

xtitle(){ ## display string in window title
    printf "\033]0;$HOSTNAME: [$*] \007"
}

_vi(){ ## backup edited files
    printf "\033]0;$HOSTNAME:[vi $*] \007"
    if [ ! -d ~/.bak ]   # make sure the backup directory is in place
    then
        mkdir ~/.bak
    fi

    for FILE in $*       # for each file passed to it
    do
        if [ -f $FILE ]  # check to see if it's a file and not an argument
        then
            NAME=$(echo $FILE| tr '/' '_') # this converts / to _ in the name
            [ -f ~/.bak/$NAME.4 ] && mv ~/.bak/$NAME.4  ~/.bak/$NAME.5
            [ -f ~/.bak/$NAME.3 ] && mv ~/.bak/$NAME.3  ~/.bak/$NAME.4
            [ -f ~/.bak/$NAME.2 ] && mv ~/.bak/$NAME.2  ~/.bak/$NAME.3
            [ -f ~/.bak/$NAME.1 ] && mv ~/.bak/$NAME.1  ~/.bak/$NAME.2
            [ -f ~/.bak/$NAME.0 ] && mv ~/.bak/$NAME.0  ~/.bak/$NAME.1
            cp $FILE ~/.bak/$NAME.0
        fi
    done

    # check to see that vim is installed and if not call vi
log "EDIT: $*"
gvim -p $*||vim -p $*||vi $*
}

fonts(){ ## connect to font server
xhost +
xset fp tcp/ustpams1:7000
xset fp rehash
}

extract(){ ## Handy Extract Program.
if [ -f $1 ] 
then
    case $1 in
        *.tar.bz2)   tar xvjf $1     ;;
        *.tar.gz)    tar xvzf $1     ;;
        *.bz2)       bunzip2 $1      ;;
        *.rar)       unrar x $1      ;;
        *.gz)        gunzip $1       ;;
        *.tar)       tar xvf $1      ;;
        *.tbz2)      tar xvjf $1     ;;
        *.tgz)       tar xvzf $1     ;;
        *.zip)       unzip $1        ;;
        *.Z)         uncompress $1   ;;
        *.7z)        7z x $1         ;;
        *)           echo "'$1' cannot be extracted via >extract<" ;;
    esac
else
    echo "'$1' is not a valid file"
fi
}

ssh(){ ## Add window title set & history feature!!
case $# in
    1) printf "\033]0;[$1]\007"
        log "SSH: $1"
        /usr/bin/ssh $1
        echo $1 >~/.ssh/last.txt;;
    2) printf "\033]0;[$1] $2\007"
        log "SSH: $1 $2"
        /usr/bin/ssh $1 $2
        echo $1 $2 >~/.ssh/last.txt;;
    0)  OPTS=$(cat ~/.ssh/last.txt)
        printf "\033]0;[$OPTS]\007"
        log "SSH: $OPTS"
        /usr/bin/ssh $OPTS;;
esac
}

mark(){ ## mark a directory for easy return, set variable to mark name.
USAGE="Usage: mark word\n\$mark    # to change directories"
case $# in
    1) export "$1=cd $PWD";;
    *) echo -e $USAGE;;
esac
}

# ending
if [ "$LOGNAME" == "$userid" ]
then
    #cd
    #today -s 2                     # personal script
    /usr/bin/uptime
    echo " "
    ##fortune
else
    echo "You are not $userid ?"
    PS1='$PWD # '
    HISTORY=0
fi
    echo " "
    echo " "

source ~/.git-completion.sh
source ~/.git-prompt.sh
source ~/.rvm/scripts/rvm
PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '



#Black       0;30     Dark Gray     1;30
#Blue        0;34     Light Blue    1;34
#Green       0;32     Light Green   1;32
#Cyan        0;36     Light Cyan    1;36
#Red         0;31     Light Red     1;31
#Purple      0;35     Light Purple  1;35
#Brown       0;33     Yellow        1;33
#Light Gray  0;37     White         1;37

Black="\[\033[0;30m\]"
Dark_Gray="\[\033[1;30m\]"
Blue="\[\033[0;34m\]"
Light_Blue="\[\033[1;34m\]"
Green="\[\033[0;32m\]"
Light_Green="\[\033[1;32m\]"
Cyan="\[\033[0;36m\]"
Light_Cyan="\[\033[1;36m\]"
Red="\[\033[0;31m\]"
Light_Red="\[\033[1;31m\]"
Purple="\[\033[0;35m\]"
Light_Purple="\[\033[1;35m\]"
Brown="\[\033[0;33m\]"
Yellow="\[\033[1;33m\]"
Light_Gray="\[\033[0;37m\]"
White="\[\033[1;37m\]"

GIT_PS1_SHOWDIRTYSTATE=true
umask 022

export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
export PS1=$White"\u@\h"'$(
    if [[ $(__git_ps1) =~ \*\)$ ]]
    then echo "'$Yellow'"$(__git_ps1 " (%s)")
    elif [[ $(__git_ps1) =~ \+\)$ ]]
    then echo "'$Purple'"$(__git_ps1 " (%s)")
    else echo "'$Cyan'"$(__git_ps1 " (%s)")
    fi)'$Green" \n\w"$White": "
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_112.jdk/Contents/Home
export SENCHA_CMD_3_0_0="/Users/$userid/bin/Sencha/Cmd/5.1.3.61"
export NODE_PATH=~/.node_libraries:~/.npm:~/node_modules
export OPENSSL_HOME=/usr/local/Cellar/openssl/1.0.2j
export APACHE_HOME=/usr/local/apache2
export ANT_HOME=/wdrive/opt/apache/ant
#export LD_LIBRARY_PATH=/usr/loca/ssl/lib:$LD_LIBRARY_PATH
#export CXF_HOME=/media/USB-LNX/opt/apache/cxf/231
#export GRADLE_HOME=/wdrive/opt/tools/gradle
#export GANT_HOME=/wdrive/opt/tools/gant
#export CLOJURE_HOME=/wdrive/opt/lang/clojure
export RUBY_HOME=~/.rvm/rubies/default
#export GROOVY_HOME=/wdrive/opt/lang/groovy
#export SCALA_HOME=/wdrive/opt/lang/scala
export ANDROID_SDK_ROOT=/wdrive/opt/google/sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export NDK_ROOT=/wdrive/opt/google/ndk
export GDK_NATIVE_WINDOWS=true

export PATH=/Users/$userid/bin/Sencha/Cmd/5.1.3.61:$PATH
export PATH=$ANDROID_SDK_ROOT:$NDK_ROOT:$PATH
export PATH=$RUBY_HOME/bin:$PATH
export PATH=$APACHE_HOME/bin:$PATH
#export PATH=$GRADLE_HOME/bin:$GANT_HOME/bin:$PATH
export PATH=$OPENSSL_HOME/bin:/usr/local/ssl/bin:$PSQL:$PATH
export PATH=~/.skaro/bin:~/.rvm/bin:$ANT_HOME/bin:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/ssl/bin:$PATH
export PATH=~/bin:$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH

# Add environment variable COCOS_X_ROOT for cocos2d-x
export FUSILLI_SRC=/wdrive/myspace/fusilli/src/main/cpp
export COCOS_X_ROOT=/wdrive/games/cocos2d
export COCOS2DX_HOME=/wdrive/games/cocos2d/ptr
# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
export COCOS_CONSOLE_ROOT=${COCOS2DX_HOME}/tools/cocos2d-console/bin
export PATH=$COCOS_CONSOLE_ROOT:$PATH
export PATH=$COCOS_X_ROOT:$PATH
# Add environment variable COCOS_TEMPLATES_ROOT for cocos2d-x
export COCOS_TEMPLATES_ROOT=${COCOS2DX_HOME}/templates
export PATH=$COCOS_TEMPLATES_ROOT:$PATH
# Add environment variable ANT_ROOT for cocos2d-x
export ANT_ROOT=$ANT_HOME/bin

# Add GHC 7.10.2 to the PATH, via https://ghcformacosx.github.io/
export GHC_DOT_APP="/Applications/ghc-7.10.2.app"
if [ -d "$GHC_DOT_APP" ]; then
  export PATH="${HOME}/.local/bin:${HOME}/.cabal/bin:${GHC_DOT_APP}/Contents/bin:${PATH}"
fi

alias path="echo $PATH | tr ':' '\n'"

### run archey
archey
echo "user $userid logged in!"





