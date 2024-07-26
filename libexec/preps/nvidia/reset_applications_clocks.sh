#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::reset_applications_clocks()
## @brief Reset Applications Clocks
## @return Return Code
## @retval 0 Applications Clocks Have Been Successfully Reset
## @retval 1 Applications Clocks Could Not Be Reset
## @ingroup nvidia
#-------------------------------------------------------------------------------
preps::nvidia::reset_applications_clocks() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local id
	for id in $(apis::nvsmi::get_gpu_indexes); do
		if apis::nvsmi::reset_applications_clocks -id "${id}"; then
			main::log_event -level "INFO" -message "NVIDIA Applications Clocks Reset to Default Configuration"
		else
			main::log_event -level "ERROR" -message "Failed to Reset NVIDIA Applications Clocks to Default Configuration - Return Code: [$?]"
			rc=1
		fi
	done
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
