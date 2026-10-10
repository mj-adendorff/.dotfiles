export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="/usr/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

export PATH="$PATH:/home/mjadendorff/.local/bin"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

alias tf="terraform"
export LLAMA_CPP_BASE_URL="http://192.168.0.168:8000"

export VISAUL="nvim"
export EDITOR="nvim"
alias posting_dev="posting --collection /home/mjadendorff/Code/quicklysign-collection --env /home/mjadendorff/Code/quicklysign-collection/dev.env"

export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
export JIRA_EMAIL="mj@quicklysign.com"
export JIRA_TOKEN="ATATT3xFfGF0C5Pna3nRFGKmHxpnZOYHkCjZmThDFeDdAnyyKCz4l_LIgewagpxns58ylEMp42X3PwgztfU5cXF3xmrW2mmj5d4TbhSbBstmm733-IWg9z4wZ5zQljYk_CxtS3FlFW3i4cxI8lawcxOvBYXekDKKvieIdiLU8joWp9dyFZNPjGE=FE5114AC"
export JIRA_HOST="https://quicklysign-team.atlassian.net"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/mjadendorff/Applications/google-cloud-sdk/path.zsh.inc' ]; then . '/home/mjadendorff/Applications/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/mjadendorff/Applications/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/mjadendorff/Applications/google-cloud-sdk/completion.zsh.inc'; fi

alias config='/usr/bin/git --git-dir=/home/mjadendorff/.dotfiles/ --work-tree=/home/mjadendorff'
alias pdf="sioyek"
alias pdftui="bookokrat"

# opencode
export PATH=/home/mjadendorff/.opencode/bin:$PATH
export PATH=/home/mjadendorff/.cargo/bin:$PATH

# Added by codebase-memory-mcp install
export PATH="/home/mjadendorff/.local/bin:$PATH"
export PATH="/home/mjadendorff/.bun/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
