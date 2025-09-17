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


export VISAUL="nvim"
export EDITOR="nvim"


# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/Applications/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/Applications/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/Applications/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/Applications/google-cloud-sdk/completion.zsh.inc'; fi

alias config='/usr/bin/git --git-dir=/home/mjadendorff/.dotfiles/ --work-tree=/home/mjadendorff'
alias lazygit-local='lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
