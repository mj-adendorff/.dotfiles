export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="/usr/bin:$PATH"
plugins=(git)

#export PYENV_ROOT="$HOME/.pyenv"
#[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init - bash)"

export PATH="$PATH:/home/mjadendorff/.local/bin"

alias tf="terraform"
export LLAMA_CPP_BASE_URL="http://192.168.0.168:8000"

export VISAUL="nvim"
export EDITOR="nvim"
alias posting_dev="posting --collection /home/mjadendorff/Code/quicklysign-collection --env /home/mjadendorff/Code/quicklysign-collection/dev.env"

export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

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
