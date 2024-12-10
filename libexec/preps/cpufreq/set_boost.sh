#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::cpufreq::set_boost()
## @brief Enable or Disable CPU Frequency Boost
## @param boost Frequency Boost Status: {0 | 1}
## @return Return Code
## @retval 0 Successfully Set CPU Frequency Boost
## @retval 1 Failed to Set CPU Frequency Boost
## @ingroup cpufreq
# ------------------------------------------------------------------------------
preps::cpufreq::set_boost() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local boost="${1}"
	[[ -n "${boost}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [Boost]"
	(( boost == 0 || boost == 1 )) || main::log_event -level "FATAL" -message "Invalid Boost Value: [${boost}]"
	echo "${boost}" >"/sys/devices/system/cpu/cpufreq/boost" || \
		{ main::log_event -level "ERROR" -message "Failed to Set CPU Boost"; rc=1; } 
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
