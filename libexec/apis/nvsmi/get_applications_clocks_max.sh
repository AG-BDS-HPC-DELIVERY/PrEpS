#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::nvsmi::get_applications_clocks_max()
## @brief Get Max. Applications Clocks
## @param id GPU ID
## @return Return Code
## @retval 0
## @ingroup nvsmi
#-------------------------------------------------------------------------------
apis::nvsmi::get_applications_clocks_max() {
	while (( $# > 0 )); do
		case "${1}" in
			-id)
				local id="${2}"
				shift
				;;
			*)
				main::log_event -level "FATAL" -message "Invalid Option: [${1}]"
				;;
		esac
		shift
	done
	[[ -n "${id}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [GPU ID]"
	(( id >= 0 )) || main::log_event -level "FATAL" -message "Invalid GPU ID: [${id}]"
	local clocks
	clocks="$("${NVSMI_EXECBIN}" --format="csv,noheader,nounits" --id="${id}" --query-gpu="clocks.max.memory,clocks.max.graphics")"
	clocks="${clocks// /}"
	printf "%s" "${clocks}"
	return 0
}
