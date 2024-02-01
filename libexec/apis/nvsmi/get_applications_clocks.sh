#!/usr/bin/env bash

apis::nvsmi::get_applications_clocks() {
	while (( $# > 0 )); do
		case "${1}" in
			-id)
				local id="${2}"
				shift
				;;
			*)
				main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Invalid Option: [${1}]"
				;;
		esac
		shift
	done
	if [[ -z "${id}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [ID]"
	fi
	local clocks
	clocks="$("${NVSMI_EXECBIN}" --format="csv,noheader,nounits" --id="${id}" --query-gpu="clocks.applications.memory,clocks.applications.graphics")"
	clocks="${clocks// /}"
	printf "%s" "${clocks}"
	return 0
}
