#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::systemd::restart_systemd_unit()
## @brief Reload systemd Unit
## @param unit systemd Unit
## @param max_active_time Maximum Active Time (Unit: Seconds)
## @return Return Code
## @retval 0 systemd Unit Has Been Successfully Restarted
## @retval 1 systemd Unit Daemon Could Not Be Restarted
## @ingroup systemd
# ------------------------------------------------------------------------------
preps::systemd::restart_systemd_unit() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local unit="${1}"
	local max_active_time="${2}"
	[[ -n "${unit}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [systemd Unit]"
	[[ -n "${max_active_time}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [Max. Active Time]"
	(( max_active_time > 0 )) || main::log_event -level "FATAL" -message "Invalid Max. Active Time: [${max_active_time}]"
	if systemctl is-active "${unit}" &>/dev/null; then
		local timestamp1 && timestamp1="$(awk '{printf "%.0f", $1}' "/proc/uptime")"
		local timestamp2 && timestamp2="$(systemctl show "${unit}" --property=ActiveEnterTimestampMonotonic | awk -F '=' '{printf "%.0f", $2/(1000*1000)}')"
		local active_time=$(( timestamp1 - timestamp2 ))
		if (( active_time > max_active_time )); then
			main::log_event -level "DEBUG" -message "Actual Runtime: [${active_time}] Greater Than Maximum Runtime: [${max_active_time}] - Restarting Service: [${unit}]"
			if ${SUDO} systemctl restart "${unit}" &>/dev/null; then
				main::log_event -level "INFO" -message "Restarted systemd Unit: [${unit}]"
			else
				main::log_event -level "ERROR" -message "Failed to Restart systemd Unit: [${unit}] - Return Code: [$?]"
				rc=1
			fi
		else
			main::log_event -level "DEBUG" -message "Actual Runtime: [${active_time}] Less Than Maximum Runtime: [${max_active_time}] - Skipping Service Restart: [${unit}]"
		fi
	fi
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
