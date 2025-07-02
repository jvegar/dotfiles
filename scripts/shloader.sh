#!/bin/bash

# Define end_shloader function first
end_shloader() {
  if [ ! -z "${shloader_pid+x}" ]; then
    kill "${shloader_pid}" &>/dev/null || true
  fi
  tput cnorm >&2 || true
  if [ ! -z "${ending+x}" ]; then
    printf "\r\033[K%s\n" "${ending}" >&2
  fi
}

# Set options and trap after function definition
set -Eeuo pipefail
trap end_shloader SIGINT SIGTERM ERR EXIT RETURN
tput civis >&2

# Loaders
# EMOJIS
emoji_hour=( 0.08 '🕛' '🕐' '🕑' '🕒' '🕓' '🕔' '🕕' '🕖' '🕗' '🕘' '🕙' '🕚')
emoji_face=( 0.08 '😐' '😀' '😍' '🙄' '😒' '😨' '😡')
emoji_earth=( 0.1 🌍 🌎 🌏 )
emoji_moon=( 0.08 🌑 🌒 🌓 🌔 🌕 🌖 🌗 🌘 )
emoji_orange_pulse=( 0.1 🔸 🔶 🟠 🟠 🔶 )
emoji_blue_pulse=( 0.1 🔹 🔷 🔵 🔵 🔷 )
emoji_blink=( 0.06 😐 😐 😐 😐 😐 😐 😐 😐 😐 😑 )
emoji_camera=( 0.05 📷 📷 📷 📷 📷 📷 📷 📷 📷 📷 📷 📷 📷 📷 📷 📷 📷 📷 📷 📷 📸 📷 📸 )
emoji_sick=( 0.2 🤢 🤢 🤮 )
emoji_monkey=( 0.2 🙉 🙈 🙊 🙈 )
emoji_bomb=( 0.2 '💣   ' ' 💣  ' '  💣 ' '   💣' '   💣' '   💣' '   💣' '   💣' '   💥' '    ' '    ' )
# ASCII
ball=( 0.2 '(●)' '(⚬)')
arrow=( 0.06 '↑' '↗' '→' '↘' '↓' '↙' '←' '↖')
cym=( 0.1 '⊏' '⊓' '⊐' '⊔')
x_plus=( 0.08 '×' '+')
line=( 0.08 '☰' '☱' '☳' '☷' '☶' '☴')
ball_wave=( 0.1 '𓃉𓃉𓃉' '𓃉𓃉∘' '𓃉∘°' '∘°∘' '°∘𓃉' '∘𓃉𓃉')
old=( 0.07 '—' "\\" '|' '/' )
dots=( 0.04 '⣾' '⣽' '⣻' '⢿' '⡿' '⣟' '⣯' '⣷' )
dots2=( 0.04 '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏' )
dots3=( 0.04 '⠋' '⠙' '⠚' '⠞' '⠖' '⠦' '⠴' '⠲' '⠳' '⠓' )
dots4=( 0.04 '⠄' '⠆' '⠇' '⠋' '⠙' '⠸' '⠰' '⠠' '⠰' '⠸' '⠙' '⠋' '⠇' '⠆' )
dots5=( 0.04 '⠋' '⠙' '⠚' '⠒' '⠂' '⠂' '⠒' '⠲' '⠴' '⠦' '⠖' '⠒' '⠐' '⠐' '⠒' '⠓' '⠋' )
dots6=( 0.04 '⠁' '⠉' '⠙' '⠚' '⠒' '⠂' '⠂' '⠒' '⠲' '⠴' '⠤' '⠄' '⠄' '⠤' '⠴' '⠲' '⠒' '⠂' '⠂' '⠒' '⠚' '⠙' '⠉' '⠁' )
dots7=( 0.04 '⠈' '⠉' '⠋' '⠓' '⠒' '⠐' '⠐' '⠒' '⠖' '⠦' '⠤' '⠠' '⠠' '⠤' '⠦' '⠖' '⠒' '⠐' '⠐' '⠒' '⠓' '⠋' '⠉' '⠈' )
dots8=( 0.04 '⠁' '⠁' '⠉' '⠙' '⠚' '⠒' '⠂' '⠂' '⠒' '⠲' '⠴' '⠤' '⠄' '⠄' '⠤' '⠠' '⠠' '⠤' '⠦' '⠖' '⠒' '⠐' '⠐' '⠒' '⠓' '⠋' '⠉' '⠈' '⠈' )
dots9=( 0.04  '⢹' '⢺' '⢼' '⣸' '⣇' '⡧' '⡗' '⡏' )
dots10=( 0.04  '⢄' '⢂' '⢁' '⡁' '⡈' '⡐' '⡠' )
dots11=( 0.04 '⠁' '⠂' '⠄' '⡀' '⢀' '⠠' '⠐' '⠈' )


die() {
  local code=${2-1}
  exit "$code"
}


usage() {
  cat <<EOF

Available options:

-h, --help            <OPTIONAL>    Print this help and exit
-l, --loader          <OPTIONAL>   Chose loader to display
-m, --message         <OPTIONAL>    Text to display while loading
-e, --ending          <OPTIONAL>    Text to display when finishing

EOF
  exit 0
}


play_shloader() {
  while true ; do
    for frame in "${loader[@]}" ; do
      printf "\r%s" "${frame} ${message}" >&2
      sleep "${speed}"
    done
  done
}

shloader() {
  loader=''
  message=''
  ending=''

  while :; do
    case "${1-}" in
    -h | --help) usage;;
    -l | --loader)
      loader="${2-}"
      shift
      ;;
    -m | --message)
      message="${2-}"
      shift
      ;;
    -e | --ending)
      ending="${2-}"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  if [[ -z "${loader}" ]] ; then
    loader=dots[@] 
  else
    loader=$loader[@]
  fi

  loader=( ${!loader} )
  speed="${loader[0]}"
  unset "loader[0]"

  tput civis >&2
  play_shloader &
  shloader_pid="${!}"
}
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  shloader
fi