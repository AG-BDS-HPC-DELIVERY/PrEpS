#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::cpufreq::set_frequency()
## @brief Set CPU Frequency
## @param frequency CPU Frequency
## @return Return Code
## @retval 0 Successfully Set CPU Frequency
## @retval 1 Failed to Set CPU Frequency
## @ingroup cpufreq
#-------------------------------------------------------------------------------
preps::cpufreq::set_frequency() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local frequency="${1}"
	[[ -n "${frequency}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [CPU Frequency]"
	if [[ "$(apis::cpupower::get_governor)" == "userspace" ]] && [[ "$(apis::cpupower::get_frequency)" != "${frequency}" ]]; then
		if apis::cpupower::set_frequency -frequency "${frequency}"; then
			main::log_event -level "INFO" -message "Set CPU Frequency: [${frequency}]"
		else
			main::log_event -level "ERROR" -message "Failed to Set CPU Frequency: [${frequency}] - Return Code: [$?]"
			rc=1
		fi
	else
		main::log_event -level "INFO" -message "Skipped Setting of CPU Frequency"
	fi
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
