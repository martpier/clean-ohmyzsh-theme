# Adapted from https://github.com/tobyjamesthomas/pi/blob/master/pi.zsh-theme

PROMPT='$(remote_prefix)%{$fg_bold[cyan]%}$(get_pwd)%{$reset_color%} $(git_prompt_info)$(git_remote_status)${prompt_suffix}'

function remote_prefix() {
  if [[ -n "$SSH_CONNECTION" ]]; then
    echo "%{$fg[red]%}⌁%{reset_color%} "
  else
    echo ""
  fi
}

local prompt_suffix="%(?:%{$fg_bold[green]%}:%{$fg[red]%})❯%{$reset_color%} "

precmd() {
  print ""
  RPROMPT=''
}

# by shashankmehta (https://github.com/shashankmehta)
function get_pwd(){
  git_root=$PWD
  while [[ $git_root != / && ! -e $git_root/.git ]]; do
    git_root=$git_root:h
  done
  if [[ $git_root = / ]]; then
    unset git_root
    prompt_short_dir=%~
  else
    parent=${git_root%\/*}
    prompt_short_dir=${PWD#$parent/}
  fi
  echo $prompt_short_dir
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}●"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$fg_bold[yellow]%}↑%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="%{$fg_bold[yellow]%}↓%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="%{$fg_bold[yellow]%}↓↑%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE=""

RPROMPT=''
_kube_update_visibility() {
  if [[ "$BUFFER" == k* && "$RPROMPT" == '' ]]; then
    local ctx ns
    ctx=$(kubectl config current-context 2>/dev/null) || return
    ns=$(kubectl config view --minify -o jsonpath='{..namespace}' 2>/dev/null)
    RPROMPT="%{$fg[magenta]%}${ctx}:${ns:-default}%{$reset_color%}"
    zle reset-prompt
  fi

  if [[ "$BUFFER" != k* && "$RPROMPT" != '' ]]; then
    RPROMPT=''
    zle reset-prompt
  fi
}
autoload -Uz add-zle-hook-widget
add-zle-hook-widget line-pre-redraw _kube_update_visibility
