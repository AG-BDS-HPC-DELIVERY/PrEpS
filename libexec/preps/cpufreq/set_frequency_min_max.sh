#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::cpufreq::set_frequency_min_max()
## @brief Set CPU Min./Max. Frequency
## @param frequencies Min./Max. Frequencies: FREQ_MIN,FREQ_MAX
## @return Return Code
## @retval 0 Successfully Set CPU Min./Max. Frequency
## @retval 1 Failed to Set CPU Min./Max. Frequency
## @ingroup cpufreq
#-------------------------------------------------------------------------------
preps::cpufreq::set_frequency_min_max() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local frequencies && IFS=":" read -a frequencies -r <<<"${1}"
	local frequency_min="${frequencies[0]}"
	local frequency_max="${frequencies[1]}"
	if [[ -z "${frequency_max}" ]]; then
		main::log_event -level "FATAL" -message "Missing Argument: [Frequency Max.]"
	fi
	if [[ -z "${frequency_min}" ]]; then
		main::log_event -level "FATAL" -message "Missing Argument: [Frequency Min.]"
	fi
	if (( frequency_min > frequency_max )); then
		main::log_event -level "FATAL" -message "Invalid Arguments: [Frequency Min.] Is Greater Than [Frequency Max.]"
	fi
	if [[ "$(apis::cpupower::get_frequency_max)" != "${frequency_max}" ]] || [[ "$(apis::cpupower::get_frequency_min)" != "${frequency_min}" ]]; then
		if apis::cpupower::set_frequency_minmax -frequency_max "${frequency_max}" -frequency_min "${frequency_min}"; then
			main::log_event -level "INFO" -message "Set CPU Frequency Min.: [${frequency_min}] / Max.: [${frequency_max}]"
		else
			main::log_event -level "ERROR" -message "Failed to Set CPU Frequency Min.: [${frequency_min}] / Max.: [${frequency_max}] - Return Code: [$?]"
			rc=1
		fi
	else
		main::log_event -level "INFO" -message "Skipped Setting of CPU Frequency Min./Max."
	fi
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
