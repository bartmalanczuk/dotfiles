function _fzf_dirs() {
  echo "desktop-app"
  echo "ecp"
  echo "nordpass-ui"
}

function _fzf_tmux() {
  # _fzf_dirs | fzf --tmux 50% | tmux new-window -c ~/Projects/ecp
  _fzf_dirs | fzf --tmux 50% | xargs -I {} tmux new-window -c ~/Projects/{}
}

zle -N _fzf_tmux
bindkey '^g' _fzf_tmux
