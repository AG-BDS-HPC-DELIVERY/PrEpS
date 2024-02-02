#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::nvsmi::get_compute_mode()
## @brief Get Compute Mode
## @param id GPU ID
## @return Return Code
## @retval 0
## @ingroup nvsmi
#-------------------------------------------------------------------------------
apis::nvsmi::get_compute_mode() {
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
	"${NVSMI_EXECBIN}" --format="csv,noheader,nounits" --id="${id}" --query-gpu="compute_mode"
	return 0
}
