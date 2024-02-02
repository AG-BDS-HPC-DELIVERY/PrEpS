#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::os::cleanup_memory_caches()
## @brief Cleanup Memory Caches
## @return Return Code
## @retval 0 Dropped Memory Caches
## @retval 1 Failed to Drop Memory Caches
## @ingroup os
#-------------------------------------------------------------------------------
preps::os::cleanup_memory_caches() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local drop_caches="${1}"
	if [[ -z "${drop_caches}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [Drop Caches]"
	fi
	if (( drop_caches != 1 )) && (( drop_caches != 2 )) && (( drop_caches != 3 )); then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Invalid Drop Caches Value: [${drop_caches}]"
	fi
	/usr/bin/sync
	if ${SUDO} /sbin/sysctl vm.drop_caches=${drop_caches} &>/dev/null; then
		main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Dropped Memory Caches"
	else
		main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed to Drop Memory Caches - Return Code: [$?]"
		rc=1
	fi
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
