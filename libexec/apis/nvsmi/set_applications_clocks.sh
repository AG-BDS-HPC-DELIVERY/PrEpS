#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::nvsmi::set_applications_clocks()
## @brief Set Applications Clocks: Memory/Graphics
## @param applications_clocks Applications Clocks: MEMORY,GRAPHICS
## @param id GPU ID
## @return Return Code
## @retval NVIDIA SMI Command Return Code
## @ingroup nvsmi
#-------------------------------------------------------------------------------
apis::nvsmi::set_applications_clocks() {
	while (( $# > 0 )); do
		case "${1}" in
			-appclocks|--applications_clocks)
				local applications_clocks="${2}"
				shift
				;;
			-id|--id)
				local id="${2}"
				shift
				;;
			*)
				main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Invalid Option: [${1}]"
				;;
		esac
		shift
	done
	if [[ -z "${applications_clocks}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [Applications Clocks]"
	fi
	if [[ -z "${id}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [ID]"
	fi
	${SUDO} "${NVSMI_EXECBIN}" --applications-clocks="${applications_clocks}" --id="${id}"
	return $?
}
