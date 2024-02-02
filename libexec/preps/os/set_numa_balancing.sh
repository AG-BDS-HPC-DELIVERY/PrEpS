#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::os::set_numa_balancing()
## @brief Set NUMA Balancing
## @param balancing NUMA Balancing
## @return Return Code
## @retval 0 Successfully Set NUMA Balancing
## @retval 1 Failed to Set NUMA Balancing
## @ingroup os
#-------------------------------------------------------------------------------
preps::os::set_numa_balancing() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local balancing="${1}"
	if [[ -z "${balancing}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [NUMA Balancing]"
	fi
	if (( balancing != 0 )) && (( balancing != 1 )); then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Invalid NUMA Balancing Value: [${balancing}]"
	fi
	echo "${balancing}" >"/proc/sys/kernel/numa_balancing" || \
		{ main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed to Set NUMA Balancing"; rc=1; } 
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
