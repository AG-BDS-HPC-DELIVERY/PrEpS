#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::reload_persistence_daemon()
## @brief Reload Persistence Daemon
## @param max_active_time Maximum Daemon Active Time
## @return Return Code
## @retval 0 Persistence Daemon Has Been Successfully Reloaded
## @retval 1 Persistence Daemon Could Not Be Reloaded
## @ingroup nvidia
#-------------------------------------------------------------------------------
preps::nvidia::reload_persistence_daemon() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local unit="nvidia-persistenced.service"
	local max_active_time="${1}"
	if [[ -z "${max_active_time}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [Max. Active Time]"
	fi
	local timestamp1 && timestamp1="$(awk '{printf "%.0f", $1}' "/proc/uptime")"
	local timestamp2 && timestamp2="$(systemctl show ${unit} --property=ActiveEnterTimestampMonotonic | awk -F '=' '{printf "%.0f", $2/(1000*1000)}')"
	local active_time=$(( timestamp1 - timestamp2 ))
	if (( active_time > max_active_time )); then
		if systemctl restart "${unit}" &>/dev/null; then
			main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Restarted NVIDIA Persistence Daemon"
		else
			main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed to Restart NVIDIA Persistence Daemon - Return Code: [$?]"
			rc=1
		fi
	else
		main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Maximum Runtime Not Exceeded - Skipping NVIDIA Persistence Service Restart"
	fi
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
