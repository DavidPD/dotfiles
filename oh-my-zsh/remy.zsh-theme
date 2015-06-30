# vim:ft=zsh ts=2 sw=2 sts=2
#
# Based on agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://gist.github.com/1595572).
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

# U+E0A0     Version control branch
# U+E0A1     LN (line) symbol
# U+E0A2     Closed padlock
# U+E0B0     Rightwards black arrowhead
# U+E0B1     Rightwards arrowhead
# U+E0B2     Leftwards black arrowhead
# U+E0B3     Leftwards arrowhead

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

ONLINE='%{%F{green}%}◉'
OFFLINE='%{%F{red}%}⦿'

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$user%m"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    ZSH_THEME_GIT_PROMPT_DIRTY='±'
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment green black
    fi
    echo -n "${ref/refs\/heads\// }$dirty"
    #work in progress branch, functions are in mygit plugin.
    if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
      echo -n " WIP!!"
    fi
  fi
}

function prompt_online() {
  if [[ -f ~/.offline ]]; then
    echo $OFFLINE
  else
    echo $ONLINE
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment blue black '%~'
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

# Virtualenv
# Shows the current virtualenv (if there is one)
prompt_virtualenv() {
  # Get Virtual Env
  if [[ -n "$VIRTUAL_ENV" ]]; then
      # Strip out the path and just leave the env name
      venv="${VIRTUAL_ENV##*/}"
  else
      # In case you don't have one activated
      venv=''
  fi
  [[ -n "$venv" ]] && prompt_segment cyan black "($venv)"
}

# Git remote:
# Am I behind or ahead?
prompt_git_remote() {

  local remote ahead behind gitab

  remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
    --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

  if [[ -n ${remote} ]] ; then
    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

    if (( $ahead || $behind )) ; then
      (( $ahead )) && gitab+=( "%{%F{green}%}+${ahead//[[:blank:]]/}%{%F{default}%}" )
      (( $ahead && $behind)) && gitab+="/"
      (( $behind )) && gitab+=( "%{%F{red}%}-${behind//[[:blank:]]/}%{%F{default}%}" )
      # prompt_segment black default "[${gitab//[[:blank:]]/}]"
      echo "[${gitab//[[:blank:]]/}]"
    fi

    # hook_com[branch]="${hook_com[branch]} [${remote} ${(j:/:)gitstatus}]"
  fi
}

prompt_git_stashed() {
  local stashed
  stashed=$(command git stash list | wc -l)
  if (( stashed != 0 )); then
    echo " %{%F{magenta}%}⧪$stashed%{%F{default}%}";
  fi
}

prompt_git_changed() {
  local changed

  changed=$(command git diff --numstat | wc -l)
  if ((changed != 0)) ; then
    echo " %{%F{yellow}%}⍜${changed//[[:blank:]]/}%{%F{default}%}"
  fi
}

prompt_git_staged() {
  local staged
  staged=$(command git diff --cached --numstat | wc -l)
  if ((staged != 0)) ; then
    echo " %{%F{green}%}⦿${staged//[[:blank:]]/}%{%F{default}%}"
  fi
}

prompt_git_added() {
  local added
  added=$(command git ls-files --exclude-standard --others | wc -l)
  if ((added != 0)) ; then
    echo " %{%F{cyan}%}+${added//[[:blank:]]/}%{%F{default}%}"
  fi
}

prompt_git_published() {
  local remotes upstream
  remotes=$(git remote | wc -l)
  if (( $remotes != 0)); then
    upstream=$(command git rev-parse --abbrev-ref ${hook_com[branch]}@{upstream} 2>/dev/null)
    if [[ $? == 0 ]]; then
      # echo "tracks"
    else
      echo " %{$fg_bold[red]%}unpublished%{$fg_no_bold[default]%}"
    fi
  fi
}

function battery_charge {
  echo `~/bin/batcharge.py`
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_git
  # prompt_git_remote
  prompt_dir
  prompt_end
}

build_right_prompt() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    prompt_git_remote
    prompt_git_stashed
    # prompt_git_added
    prompt_git_staged
    # prompt_git_changed
    # prompt_git_published
  fi
}

RPROMPT='$(build_right_prompt)'

PROMPT='%{%f%b%k%}$(build_prompt)
❯ '
