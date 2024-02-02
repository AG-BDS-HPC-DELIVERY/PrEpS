#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::check_residual_user_processes()
## @brief Check Residual User Processes
## @return Return Code
## @retval 0 No Residual User Process Found
## @retval 1 Residual User Processes Found
## @ingroup nvidia
#-------------------------------------------------------------------------------
preps::nvidia::check_residual_user_processes() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	if (( $(apis::nvsmi::get_gpu_count) > 0 )); then
		local processes
		readarray -t processes < <(${NVSMI_EXECBIN} --format=csv,noheader --query-compute-apps=pid,name 2>/dev/null | awk '!/nvidia-cuda-mps-server/')
		if (( ${#processes[@]} > 0 )); then
			main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Residual User Processes Found - Total Count: [${#processes[@]}] - First Process: [${processes[0]}]"
			rc=1
		else
			main::log_event -level "${LOGGER_LEVEL_INFO}" -message "No Residual User Process Found"
		fi
	else
		main::log_event -level "${LOGGER_LEVEL_DEBUG}" -message "No Visible GPU Device - Skipping Health Check"
	fi
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
