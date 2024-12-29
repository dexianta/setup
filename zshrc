# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/dexian/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="dexian"


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#
# plugins
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#cc0000,bold"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# eval "$(/opt/homebrew/bin/brew shellenv)"

# Alias
alias dk='docker kill $(docker ps -q)'
alias vim=nvim
alias v=nvim
alias k=kubectl
alias sshpw='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no '
alias gil='gh issue list'
alias gic='gh issue create'
alias giv='gh issue view'
alias grl='gh run list'
alias gpl='gh pr list'
alias gpv='gh pr view'
alias gpc='gh pr create'

psqll () {
    psql "host=localhost port=5433 dbname=$1 user=test password=test sslmode=disable"
}

psqlx () {
    psql "host=localhost port=5432 dbname=$1 user=user password=pwd sslmode=disable" $@
}

export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$PATH:/usr/local/opt/riscv-gnu-toolchain/bin"
export PATH="$PATH:$(brew --prefix)/opt/llvm/bin"
#export CFLAGS="-g -Wall -Wextra -pedantic -Werror -target x86_64-apple-darwin20.3.0"



rmi () {
    docker images | grep "$1" | awk '{print $3}' | xargs docker rmi -f  
}

klf () {
  kubectl logs -f deploy/$1 -n $2
}

kl () {
  kubectl logs deploy/$1 -n $2
}

certt () {
    openssl s_client -connect $1:443 -servername $1 </dev/null 2>/dev/null | openssl x509 -noout -dates
}


# >>> conda initialize >>>
source  ~/miniconda3/bin/activate

export PATH=$PATH:/Users/dexian/bin

# The next line updates PATH for the Google Cloud SDK.
#if [ -f '/Users/dexian/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dexian/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
#if [ -f '/Users/dexian/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dexian/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

tls () {
  for url in "api.causalfoundry.ai" "api-dev.causalfoundry.ai" "api-charm.m2m.org" "api-dev-charm.m2m.org" "api.aidechemist.com" "api-dev.aidechemist.com"; do
    echo $url
    echo | openssl s_client -connect $url:443 -servername $url 2>/dev/null | openssl x509 -noout -dates
  done
}
