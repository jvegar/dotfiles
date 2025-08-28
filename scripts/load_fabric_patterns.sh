# Fabric aliases configuration
if [ -d "$HOME/.config/fabric/patterns" ]; then
  for pattern_file in $HOME/.config/fabric/patterns/*; do
    if [ -d "$pattern_file" ]; then
      pattern_name=$(basename "$pattern_file")
      unalias "$pattern_name" 2>/dev/null

      eval "
      $pattern_name() {
        local title=\$1
        local date_stamp=\$(date +'%Y-%m-%d')
        local output_path=\"\${OBSIDIAN_BASE}/AI\ Queries/\${date_stamp}-\${title}.md\"

        if [ -n \"\$title\" ]; then
          fabric --pattern \"$pattern_name\" -o \"\$output_path\"
        else
          fabric --pattern \"$pattern_name\" --stream
        fi
      }
    "
    fi
  done
fi

yt() {
  if [ "$#" -eq 0 ] || [ "$#" -gt 2 ]; then
    echo "Usage: yt [-t | --timestamps] youtube-link"
    echo "Use the '-t' flag to get the transcript with timestamps."
    return 1
  fi

  transcript_flag="--transcript"
  if [ "$1" = "-t" ] || [ "$1" = "--timestamps" ]; then
    transcript_flag="--transcript-with-timestamps"
    shift
  fi
  local video_link="$1"
  fabric -y "$video_link" $transcript_flag
}
