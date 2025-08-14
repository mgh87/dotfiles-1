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

bindkey -v
# Enable delete with backspace
`bindkey "^?" backward-delete-char`

# TODO get colon workin in vim
#colon-runner() {
#  zle -I
#  vared -p "command: " -c cmd
#  zle reset-prompt
#  eval "$cmd"
#}
#zle -N colon-runner
#bindkey -M vicmd ':' colon-runner

# =============================================================================
#                                   Plugins
# =============================================================================

HYPHEN_INSENSITIVE="true"
# /!\ do not use with zsh-autosuggestions

#ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[cursor]='bold'

#ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
#ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,bold'
#ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
#ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
#ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
#ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,bold'
#ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green,bold'

# Install Zi if it's not installed
if [[ ! -d "${ZDOTDIR:-$HOME}/.zi" ]]; then
  mkdir -p "${ZDOTDIR:-$HOME}/.zi"
  git clone https://github.com/z-shell/zi "${ZDOTDIR:-$HOME}/.zi/bin"
fi

source "${ZDOTDIR:-$HOME}/.zi/bin/zi.zsh"

#OH-MY-ZSH libs
zi snippet "OMZL::git.zsh"
zi snippet "OMZL::directories.zsh"


# OH-MY-ZSH Plugins
zi light-mode for \
  OMZ::plugins/colored-man-pages \
  OMZ::plugins/extract \
  OMZ::plugins/fancy-ctrl-z \
  OMZ::plugins/git \
  OMZ::plugins/tmux \
  OMZ::plugins/mvn \
  OMZ::plugins/gradle \
  OMZ::plugins/jenv \
  OMZ::plugins/aws \
  OMZ::plugins/rbenv \
  OMZ::plugins/kubectl

# External plugins and tools
zi light supercrabtree/k

zi light romkatv/powerlevel10k

# FZF with custom install hook
zi for \
  atclone'./install --bin' \
  atpull'%atclone' \
  pick'shell/key-bindings.zsh' \
  junegunn/fzf

zi light Aloxaf/fzf-tab

# dircolors-solarized - pick nothing (only sets color schemes)
zi for \
  pick'' \
  seebi/dircolors-solarized

zi light Tarrasch/zsh-bd
zi light zsh-users/zsh-autosuggestions
zi wait lucid for zsh-users/zsh-completions
zi wait lucid for zsh-users/zsh-syntax-highlighting
zi light zsh-users/zsh-history-substring-search
zi wait lucid for lukechilds/zsh-better-npm-completion
zi light gradle/gradle-completion

zi light MichaelAquilina/zsh-you-should-use
zi light mgh87/zsh-mgh-plugins

# Optional: emoji tools (commented out since you had them commented)
# zi light b4b4r07/emoji-cli \
#   atload"zi light stedolan/jq"
# zi from"gh-r" as"command" mv"jq" pick"jq" light stedolan/jq
# zi as"command" pick"emojify" light mrowa44/emojify

# Disable annoying dots in completion
COMPLETION_WAITING_DOTS=false



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

[[ ! -d $HOME/google-cloud-sdk ]] || source ~/google-cloud-sdk/completion.zsh.inc && source ~/google-cloud-sdk/path.zsh.inc

eval "$(jenv init -)"


# Load Angular CLI autocompletion.
source <(ng completion script)

# To customize prompt, run `p10k configure` or edit ~/dotfiles-1/zsh/.p10k.zsh.
[[ ! -f ~/dotfiles-1/zsh/.p10k.zsh ]] || source ~/dotfiles-1/zsh/.p10k.zsh
