#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::cpufreq::set_governor()
## @brief Set CPU Power Governor
## @param governor CPU Power Governor
## @return Return Code
## @retval 0 Successfully Set CPU Power Governor
## @retval 1 Failed to Set CPU Power Governor
## @ingroup cpufreq
#-------------------------------------------------------------------------------
preps::cpufreq::set_governor() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local governor="${1}"
	if [[ -z "${governor}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [Governor]"
	fi
	if [[ "${governor}" != "conservative" && "${governor}" != "ondemand" && "${governor}" != "performance" && "${governor}" != "powersave" && "${governor}" != "userspace" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Invalid Governor Value: [${governor}]"
	fi
	if [[ "$(apis::cpupower::get_governor)" != "${governor}" ]]; then
		if apis::cpupower::set_governor _governor "${governor}"; then
			main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Set CPU Governor: [${governor}]"
		else
			main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed to Set CPU Governor: [${governor}] - Return Code: [$?]"
			rc=1
		fi
	else
		main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Skipped Setting of CPU Governor"
	fi
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
