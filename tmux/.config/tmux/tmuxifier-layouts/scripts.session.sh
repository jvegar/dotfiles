# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/repos/projects/scripts/"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "scripts"; then

	new_window "root"

	# 4-pane grid layout:
	# ┌────────────┬─────┐
	# │ upper-left │ u-r │
	# │   80%x80%  │20%  │
	# ├────────────┼─────┤
	# │ bottom-l   │ b-r │
	# │   80%x20%  │20%  │
	# └────────────┴─────┘

	split_h 20
	select_pane 0
	split_v 20
	select_pane 2
	split_v 20
	select_pane 0
	run_cmd "nvim"

	new_window "git"
	run_cmd "lazygit"

	select_window "root"
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
