#!/usr/bin/env bash

preps::nvidia::reset_applications_clocks() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local id
	for id in $(apis::nvsmi::gpu_indexes_get); do
		if apis::nvsmi::applications_clocks_reset _id "${id}"; then
			main::log_event -level "${LOGGER_LEVEL_INFO}" -message "NVIDIA Applications Clocks Reset to Default Configuration"
		else
			main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed to Reset NVIDIA Applications Clocks to Default Configuration - Return Code: [$?]"
			rc=1
		fi
	done
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}]"
	return ${rc}
}
