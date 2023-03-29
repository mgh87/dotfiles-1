# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc., # Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
#                          Pre-Plugin Configuration
# =============================================================================

# Automagically quote URLs. This obviates the need to quote them manually when
# pasting or typing URLs.
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# Set keybindings to emacs idependent of editor
# TODO check if vi is selected and only rebind then
# TODO backspace is not working in vi mode, really annoying (insert only)
bindkey -e
# Vi keybindings
# `bindkey "^?" backward-delete-char`


# =============================================================================
#                                   Plugins
# =============================================================================

HYPHEN_INSENSITIVE="true"
# /!\ do not use with zsh-autosuggestions

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[cursor]='bold'

ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green,bold'

if [[ ! -d "${ZPLUG_HOME}" ]]; then
  if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    # If we can't get zplug, it'll be a very sobering shell experience. To at
    # least complete the sourcing of this file, we'll define an always-false
    # returning zplug function.
    if [[ $? != 0 ]]; then
      function zplug() {
        return 1
      }
    fi
  fi
  export ZPLUG_HOME=~/.zplug
fi
if [[ -d "${ZPLUG_HOME}" ]]; then
  source "${ZPLUG_HOME}/init.zsh"
fi

zplug 'plugins/colored-man-pages', from:oh-my-zsh
zplug 'plugins/extract', from:oh-my-zsh
zplug 'plugins/fancy-ctrl-z', from:oh-my-zsh
zplug 'plugins/git', from:oh-my-zsh, if:'which git'
zplug 'plugins/tmux', from:oh-my-zsh, if:'which tmux'
zplug 'plugins/mvn', from:oh-my-zsh
zplug 'plugins/gradle', from:oh-my-zsh
zplug 'plugins/jenv', from:oh-my-zsh
zplug 'plugins/aws', from:oh-my-zsh
zplug 'plugins/rbenv', from:oh-my-zsh
zplug 'plugins/kubectl', from:oh-my-zsh
# new ls
zplug 'supercrabtree/k'

# docker
zplug 'plugins/docker', from:oh-my-zsh
zplug 'plugins/docker-compose', from:oh-my-zsh
zplug 'plugins/docker-machine', from:oh-my-zsh

# theme
zplug 'romkatv/powerlevel10k', use:powerlevel10k.zsh-theme

# Fuzzy search engine
zplug "junegunn/fzf", use:"shell/key-bindings.zsh"
zplug 'Aloxaf/fzf-tab'
# ... to ../.. extention
#zplug 'knu/zsh-manydots-magic', use:manydots-magic, defer:3
zplug 'seebi/dircolors-solarized', ignore:"*", as:plugin
# backwards-jump by name 
zplug 'Tarrasch/zsh-bd'
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions', defer:2
zplug 'zsh-users/zsh-history-substring-search'
zplug 'zsh-users/zsh-syntax-highlighting', defer:2
zplug "lukechilds/zsh-better-npm-completion", defer:2

# loading parts of lib from oh-my-zsh i want
zplug 'lib/directories', from:oh-my-zsh

# removes annoying auto completion dots. credit hschne.at
COMPLETION_WAITING_DOTS=false
zplug 'gradle/gradle-completion'

# Emoji-CLI
#
# Emojis for the command line. Yes, this is absolutely needed.
# requires brew install emojify on mac
#
# Website: https://github.com/b4b4r07/emoji-cli
# TODO get it running properly
# zplug "b4b4r07/emoji-cli", on:"stedolan/jq", defer:2
# zplug "stedolan/jq", from:gh-r, as:command, rename-to:jq

# Emojis for the command line, also super important.
##zplug "mrowa44/emojify", as:command, use:emojify

## suggestiom by hans
zplug "MichaelAquilina/zsh-you-should-use"

## my plugin!
zplug "mgh87/zsh-mgh-plugins"

if ! zplug check; then
  zplug install
fi

zplug load

# Our custom version of oh-my-zsh's globalias plugin. Unlike the OMZ version,
# we do not use the `expand-word' widget and only expand a few whitelisted
# aliases.
# See https://github.com/robbyrussell/oh-my-zsh/issues/6123 for discussion.
globalias() {
  # FIXME: the whitelist pattern should technically only be computed once, but
  # since it's cheap, we keep it local for now.
  local -a whitelist candidates
  whitelist=(ls git tmux)
  local pattern="^(${(j:|:)whitelist})"
  for k v in ${(kv)aliases}; do
    # We have a candidate unless the alias is an alias that begins with itself,
    # e.g., ls='ls --some-option'.
    if [[ $v =~ $pattern && ! $v =~ ^$k ]]; then
      candidates+=($k)
    fi
  done
  if [[ $LBUFFER =~ "(^|[;|&])\s*(${(j:|:)candidates})\s*($|[;|&])" ]]; then
    zle _expand_alias
  fi
  zle self-insert
}
#zle -N globalias
#bindkey -M emacs ' ' globalias
#bindkey -M viins ' ' globalias
#bindkey -M isearch ' ' magic-space # normal space during searches


# =============================================================================
#                                   Options
# =============================================================================


# Watching other users
WATCHFMT='%n %a %l from %m at %t.'
watch=(notme)         # Report login/logout events for everybody except ourself.
LOGCHECK=60           # Time (seconds) between checks for login/logout activity.
REPORTTIME=5          # Display usage statistics for commands running > 5 sec.
WORDCHARS="\'*?_-.[]~=/&;!#$%^(){}<>\'"

# History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt autocd                   # Allow changing directories without `cd`
setopt append_history           # Do not overwrite history
setopt extended_history         # Also record time and duration of commands.
setopt share_history            # Share history between multiple shells
setopt hist_expire_dups_first   # Clear duplicates when trimming internal hist.
setopt hist_find_no_dups        # Do not display duplicates during searches.
setopt hist_ignore_dups         # Ignore consecutive duplicates.
setopt hist_ignore_all_dups     # Remember only one unique copy of the command.
setopt hist_reduce_blanks       # Remove superfluous blanks.
setopt hist_save_no_dups        # Omit older commands in favor of newer ones.

# Changing directories
setopt pushd_ignore_dups        # Do not push copies of the same dir on stack.
setopt pushd_minus              # Reference stack entries with '-'.

setopt extended_glob

# Convenience function to update system applications and user packages.
update() {
  # sudoe once
  if ! sudo -n true 2> /dev/null; then
    sudo -v
    while true; do
      sudo -n true
      sleep 60
      kill -0 "$$" || exit
    done 2>/dev/null &
  fi
  # System
  sudo softwareupdate -i -a
  # Homebrew
  brew upgrade
  brew cleanup
  # npm
  npm install npm -g
  npm update -g
  # Shell plugin management
  zplug update
  .tmux/plugins/tpm/bin/update_plugins all
  vim +PlugUpgrade +PlugUpdate +PlugCLean! +qa
}

# GPG key id
export KEYID=5686D0EBC96E9B54CC5F3367B198DAAB514B53CF

# Aliases
source $HOME/.aliases

# =============================================================================
#                                   Startup
# =============================================================================

# Load nodenv autocompletion
# eval "$(nodenv init -)"

# Source local customizations.
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ ! -f ~/.fzf.zsh ]] || source ~/.fzf.zsh

