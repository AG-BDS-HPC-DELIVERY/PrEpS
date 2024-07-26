#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::nvsmi::get_persistence_mode()
## @brief Get Persistence Mode
## @param id GPU ID
## @return Return Code
## @retval 0
## @ingroup nvsmi
#-------------------------------------------------------------------------------
apis::nvsmi::get_persistence_mode() {
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
	if [[ -z "${id}" ]]; then
		main::log_event -level "FATAL" -message "Missing Argument: [ID]"
	fi
	"${NVSMI_EXECBIN}" --format="csv,noheader,nounits" --id="${id}" --query-gpu="persistence_mode"
	return 0
}
