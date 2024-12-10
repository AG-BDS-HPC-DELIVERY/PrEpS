#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn apis::nvsmi::reset_applications_clocks()
## @brief Reset Applications Clocks
## @param id GPU ID
## @return Return Code
## @retval NVIDIA SMI Command Return Code
## @ingroup nvsmi
# ------------------------------------------------------------------------------
apis::nvsmi::reset_applications_clocks() {
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
	${SUDO} "${NVSMI_EXECBIN}" ${id:+--id="${id}"} --reset-applications-clocks
	return $?
}
