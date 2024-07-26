#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::nvsmi::set_power_limit()
## @brief Set Power Limit
## @param power_limit Power Limit
## @return Return Code
## @retval NVIDIA SMI Command Return Code
## @ingroup nvsmi
#-------------------------------------------------------------------------------
apis::nvsmi::set_power_limit() {
	while (( $# > 0 )); do
		case "${1}" in
			-power_limit)
				local power_limit="${2}"
				shift
				;;
			*)
				main::log_event -level "FATAL" -message "Invalid Option: [${1}]"
				;;
		esac
		shift
	done
	if [[ -z "${power_limit}" ]]; then
		main::log_event -level "FATAL" -message "Missing Argument: [Power Limit]"
	fi
	if ! (( power_limit > 0 )); then
		main::log_event -level "FATAL" -message "Invalid Power Limit: [${power_limit}]"
	fi
	${SUDO} "${NVSMI_EXECBIN}" --power-limit=${power_limit} --scope=1
	return $?
}
