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
			-i | --id)
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
	clocks="$("${NVSMI_EXECBIN}" --format="csv,noheader,nounits" --id="${id}" --query-gpu="clocks.max.memory,clocks.max.graphics")"
	clocks="${clocks// /}"
	printf "%s" "${clocks}"
	return 0
}
