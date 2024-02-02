#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::set_applications_clocks()
## @brief Set Applications Clocks
## @param applications_clocks Applications Clocks (<MEMORY>:<GRAPHICS>)
## @return Return Code
## @retval 0 Successfully Set Applications Clocks
## @retval 1 Failed to Set Applications Clocks
## @ingroup nvidia
#-------------------------------------------------------------------------------
preps::nvidia::set_applications_clocks() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local applications_clocks="${1}"
	if [[ -z "${applications_clocks}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [Applications Clocks]"
	fi
	local id
	for id in $(apis::nvsmi::gpu_indexes_get); do
		if [[ "$(apis::nvsmi::applications_clocks_get _id "${id}")" != "${applications_clocks}" ]]; then
			apis::nvsmi::applications-clocks-set _applications_clocks "${applications_clocks}" _id "${id}"
			if (( $? == 0 )); then
				main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Configured Applications Clocks: [${applications_clocks}] for NVIDIA GPU: [${id}]"
			else
				main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed to Configure Applications Clocks: [${applications_clocks}] for NVIDIA GPU: [${id}] - Return Code: [$?]"
				rc=1
			fi
		else
			main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Skipped Applications Clocks Configuration for NVIDIA GPU: [${id}]"
		fi
	done
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
