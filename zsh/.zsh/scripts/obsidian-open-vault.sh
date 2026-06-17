#!/bin/zsh

obsidian_open_vault() {
	if [ -z "$OBSIDIAN_BASE" ]; then
		echo "Error: OBSIDIAN_BASE environment variable is not set."
		exit 1
	fi

	cd "$OBSIDIAN_BASE" || exit
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]] || [[ "${ZSH_EVAL_CONTEXT}" == "toplevel" ]]; then
	oobsidian_open_vault
fi
