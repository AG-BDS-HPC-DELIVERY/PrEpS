#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::fs::check_mountpoints()
## @brief Check Filesystem Mountpoints
## @param mountpoints Comma-Separated List of Mountpoints
## @return Return Code
## @retval 0 All Filesystem Mountpoints Are Properly Mounted
## @retval 1 Not All Filesystem Mountpoints Are Properly Mounted
## @ingroup fs
#-------------------------------------------------------------------------------
preps::fs::check_mountpoints() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local mountpoints && IFS="," read -a mountpoints -r <<<"${1}"
	if [[ -z "${mountpoints[*]}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [Mountpoints]"
	fi
	local mountpoint
	for mountpoint in "${mountpoints[@]}"; do
		if mountpoint --quiet "${mountpoint}" &>/dev/null; then
			main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Mountpoint: [${mountpoint}] Mounted"
		else
			main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Mountpoint: [${mountpoint}] Not Mounted"
			rc=1
		fi
	done
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
