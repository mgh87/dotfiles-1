# Unless -f is specified, .zshenv is sourced on all shell invocations.
# Consequently, there should be only critical commands environment in this file.

 umask 022

# Set $PATH.
if [[ -f ~/.zpath ]]; then
  source ~/.zpath
fi

# Editor
if which vim &> /dev/null; then
  export EDITOR="vim"
elif which vi &> /dev/null; then
  export EDITOR="vi"
fi
export VISUAL=$EDITOR

# Pager.
export PAGER="less -S"

# Version control software.
export CVS_RSH="ssh"
export CVSEDITOR="vim"
export RSYNC_RSH="ssh"

# Set UTF-8 locale.
export LANG=en_US.UTF-8

# Source local environment.
if [[ -f ~/.zshenv.local ]]; then
  source ~/.zshenv.local
fi

# Setup GPG.
export GPG_TTY=$(tty);
if which gpgconf > /dev/null 2>&1; then
  export GPG_AGENT_INFO=$(gpgconf --list-dirs agent-socket)
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  gpg-connect-agent updatestartuptty /bye > /dev/null
fi

# vim: ft=zsh
