#!/usr/bin/env zsh
# ZSH Options Configuration

# Improve tab completion behavior
# setopt always_to_bottom        # Move cursor to bottom on completion (not available in all zsh versions)
setopt complete_in_word       # Complete in the middle of word
setopt magic_equal_subst        # Enable =value expansion

# Better globbing and pattern handling
setopt brace_ccl              # Expand brace ranges (e.g., {1..5})
setopt extended_glob          # Enable extended glob patterns (^, ~, #, etc.)

# Improve directory navigation
setopt auto_pushd             # Auto add directories to pushd
setopt pushd_ignore_dups    # Don't push duplicates
setopt pushd_silent            # Don't print directory on pushd/popd
# setopt pushd_to_first       # 'pushd dir' goes to second dir if no arg (not available in all zsh versions)

# Safety and compatibility options
setopt no_beep                 # Disable all beeps
setopt no_hist_beep           # Don't beep on history expansion
setopt no_list_beep           # Don't beep on ambiguous completion
# setopt no_mobile            # Optimize for desktop environments (not available in all zsh versions)