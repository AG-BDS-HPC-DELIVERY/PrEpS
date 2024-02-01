#!/usr/bin/env bash

preps::cpufreq::set_frequency_min_max() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local frequencies && IFS=":" read -a frequencies -r <<<"${1}"
	local frequency_min="${frequencies[0]}"
	local frequency_max="${frequencies[1]}"
	if [[ -z "${frequency_max}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [Frequency Max.]"
	fi
	if [[ -z "${frequency_min}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [Frequency Min.]"
	fi
	if (( frequency_min > frequency_max )); then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Invalid Arguments: [Frequency Min.] Is Greater Than [Frequency Max.]"
	fi
	if [[ "$(apis::cpupower::get-frequency_max)" != "${frequency_max}" ]] || [[ "$(apis::cpupower::get_frequency_min)" != "${frequency_min}" ]]; then
		if apis::cpupower::set-frequency-minmax -frequency_max "${frequency_max}" _frequency_min "${frequency_min}"; then
			main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Set CPU Frequency Min.: [${frequency_min}] / Max.: [${frequency_max}]"
		else
			main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed to Set CPU Frequency Min.: [${frequency_min}] / Max.: [${frequency_max}] - Return Code: [$?]"
			rc=1
		fi
	else
		main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Skipped Setting of CPU Frequency Min./Max."
	fi
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
