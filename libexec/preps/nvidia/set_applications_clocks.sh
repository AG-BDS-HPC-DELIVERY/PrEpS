#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::set_applications_clocks()
## @brief Set Applications Clocks
## @param applications_clocks Applications Clocks: MEMORY:GRAPHICS
## @return Return Code
## @retval 0 Successfully Set Applications Clocks
## @retval 1 Failed to Set Applications Clocks
## @ingroup nvidia
# ------------------------------------------------------------------------------
preps::nvidia::set_applications_clocks() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local applications_clocks="${1}"
	[[ -n "${applications_clocks}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [Applications Clocks]"
	local id
	for id in $(apis::nvsmi::get_gpu_indexes); do
		if [[ "$(apis::nvsmi::get_applications_clocks -id "${id}")" != "${applications_clocks}" ]]; then
			if apis::nvsmi::set_applications_clocks -applications_clocks "${applications_clocks}" -id "${id}"; then
				main::log_event -level "INFO" -message "Configured Applications Clocks: [${applications_clocks}] for NVIDIA GPU Device: [${id}]"
			else
				main::log_event -level "ERROR" -message "Failed to Configure Applications Clocks: [${applications_clocks}] for NVIDIA GPU Device: [${id}] - Return Code: [$?]"
				rc=1
			fi
		else
			main::log_event -level "INFO" -message "Skipped Applications Clocks Configuration for NVIDIA GPU Device: [${id}]"
		fi
	done
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
