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

# GPG
export GPG_TTY=$TTY

# OS-specific environment.
case $OSTYPE in
  darwin*)
    # Ignore reading of /etc/profile, which messes with $PATH. We re-enable
    # reading other system-wide zsh files in ~/.zprofile. See
    # http://www.zsh.org/mla/users/2015/msg00725.html for details.
    setopt no_global_rcs
    # Opt out of Homebrew analytics.
    export HOMEBREW_NO_ANALYTICS=1
    # On OSX, we install zplug via Homebrew.
    export ZPLUG_HOME=/usr/local/opt/zplug
    ;;
esac

# Source local environment.
if [[ -f ~/.zshenv.local ]]; then
  source ~/.zshenv.local
fi

# vim: ft=zsh
