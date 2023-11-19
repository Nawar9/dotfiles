# ################################# TESTING (TO DELETE) ################################# #
# plugins=(git       web-search)
# ################################# TESTING (TO DELETE) ################################# #

# Create cache and state directories
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
mkdir -p "$ZSH_CACHE_DIR"
export ZSH_STATE_DIR="${XDG_STATE_HOME}/zsh"
mkdir -p "$ZSH_STATE_DIR"

# Options
setopt GLOB_DOTS
setopt CDABLE_VARS
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt LONG_LIST_JOBS

WORDCHARS="_"

# History
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY

export HISTFILE="${ZSH_STATE_DIR}/zhistory"
export HISTSIZE=10000
export SAVEHIST=10000

# Completion (Plugins that add completion must be added to fpath before running compinit)
zmodload zsh/complist

autoload -Uz compinit && compinit -d "${ZSH_CACHE_DIR}/zcompdump"
autoload -Uz bashcompinit && bashcompinit

zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "${ZSH_CACHE_DIR}/zcompcache"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order builtins aliases functions commands
zstyle ':completion:*:*:cd:*' tag-order local-directories
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,tty,comm"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-/?]#)*=01;34=0=01'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:*:*:descriptions' format '%U%F{blue}-- %d --%f%u'
zstyle ':completion:*:*:*:*:messages' format '%U%F{yellow}-- %d --%f%u'
zstyle ':completion:*:*:*:*:warnings' format '%U%F{red}-- no matches found --%f%u'

# Directory stack
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

alias d="eval \"\$(dirs -v | fzf --no-multi --height=25% --border-label=' CD-HISTORY ' --header-lines=1 | cut -f 1)\""

for i in {1..9}; do
	alias "$i"="cd +$i";
done
unset i

# Load prompt
source "${ZDOTDIR}/zprompt"

# Load key bindings
source "${ZDOTDIR}/zbindings"

# Load rc files
source "${SHELL_HOME}/aliasrc"
source "${SHELL_HOME}/funcrc"
source "${SHELL_HOME}/startrc"

# Load fzf extensions
source "/usr/share/fzf/completion.zsh"
source "/usr/share/fzf/key-bindings.zsh"

# Load plugins
export ZSH_CUSTOM="$ZDOTDIR"

for plugin in "${ZSH_CUSTOM}/plugins/"*; do
	source "${plugin}/$(basename $plugin).plugin.zsh"
done
unset plugin
