# Personal utils for everyday use

# SETUP
# 1. Install homebrew: https://brew.sh/
# 2. Install other dependencies:
# - brew install pls-rs/pls/pls
# - brew install jq
# - brew install gource
# - brew install ffmpeg


# Fun - run Gource on new repositories
function show_gource() {
  gource --hide dirnames,filenames --seconds-per-day 0.05 --auto-skip-seconds 1 -1280x720 -o - | ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -crf 1 -threads 0 -bf 0 gource.mp4
}

# General utils
alias note='open -e'
function edit() {
  open -e $1
}

# Quick edit
alias ep='edit ~/.bash_profile'
alias rp='source ~/.bash_profile'
alias eg='edit ~/.git_profile'
alias rg='source ~/.git_profile'
alias ez='edit ~/.zshrc'
alias rz='source ~/.zshrc'


# Navigation/Finder/Filesystem utils
alias cdc='cd ~/Code'

function cdgr() {
  cd "$(gitroot)" || return 1
}

alias thf='toggle_hidden_files'
function toggle_hidden_files() {
	show=`defaults read com.apple.finder AppleShowAllFiles`

	if [ $show -eq 1 ]; then
		defaults write com.apple.finder AppleShowAllFiles 0
	else
		defaults write com.apple.finder AppleShowAllFiles 1
	fi

	killall Finder
}

function ignore() {
  mv "$1" "~/ignore/$1"
}

# Terminal utils
alias folder_sizes='du -sh */ | sort -nr'
alias ls='pls -g true'

alias psagp='psaux python'
alias psagn='psaux node | grep -v "Cursor"'
function psaux() {
  ps aux | grep "$1" | grep -v grep
}

function ip() {
  url="http://$(ifconfig en0 | grep inet | tail -n 1 | awk '{ print $2 }'):8000"

  # copy URL to clipboard
  echo $url | pbcopy
  echo "Dev URL copied to clipboard:"
  echo "$url"
}

# Node.js utils
add_types() {
  if [[ -z "$1" ]]; then
    echo "Error: missing package name"
  else
    pnpm add -D @types/"$1"
  fi
}

# Web shortcuts
alias emoji="open https://amplitude.slack.com/customize/emoji"
alias ots='open https://microsoft.github.io/TypeSearch/'

pkg() {
  open "https://www.npmjs.com/package/$1"
}

types() {
  open "https://github.com/DefinitelyTyped/DefinitelyTyped/blob/master/types/$1"
}

eslr() {
  open "https://eslint.org/docs/rules/$1"
}

tseslr() {
  open "https://typescript-eslint.io/rules/$1"
}

lodash() {
  open "https://lodash.com/docs/4.17.15#$1"
}

tw() {
  open "https://tailwindcss.com/docs/$1"
}

# JQ utils

# Usage: `json package scripts`
function json() {
  cat "$1".json | jq ."$2"
}

alias jpd='json package dependencies'
alias jpdd='json package devDependencies'
alias jps='json package scripts'

# Usage: `package name description version`
function package() {
  for var in "$@"
  do
    cat package.json | jq ."$var"
  done
}

# Coding utils
alias ts='NODE_OPTIONS=--max_old_space_size=8192 pnpm tsc --noEmit'

function _() {
  echo "import $1 from 'lodash/$1';"
}

u2i() {
  echo "type UnionToIntersection<U> = (U extends any ? (k: U)=>void : never) extends ((k: infer I)=>void) ? I : never"
}

# Pause all Node.js processes
function pausenodes() {
  pids=$(pgrep -f node)
  while IFS= read -r pid; do
    process=$(ps -p $pid -o comm=)
    if [[ "$process" == *node ]]; then
      echo "stopping process $pid - $process"
      kill -STOP "$pid"
    fi
  done <<< "$pids"
}

# Resume all paused Node.js processes
function startnodes() {
  pids=$(pgrep -f node)
  while IFS= read -r pid; do
    process=$(ps -p $pid -o comm=)
    if [[ "$process" == *node ]]; then
      echo "starting process $pid - $process"
      kill -CONT "$pid"
    fi
  done <<< "$pids"
}

function pidof() {
  echo $(pgrep -f "$1")
}

# Misc utils
function table() {
  echo "
| Before | After |
| --- | --- |
|
"
}

readme() {
  cat README.md
}
