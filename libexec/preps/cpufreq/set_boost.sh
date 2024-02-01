#!/usr/bin/env bash

preps::cpufreq::set_boost() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local boost="${1}"
	if [[ -z "${boost}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [Boost]"
	fi
	if (( boost != 0 )) && (( boost != 1 )); then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Invalid Boost Value: [${boost}]"
	fi
	echo "${boost}" >"/sys/devices/system/cpu/cpufreq/boost" || \
		{ main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed to Set CPU Boost"; rc=1; } 
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
