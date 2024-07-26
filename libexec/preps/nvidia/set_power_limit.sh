#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::set_power_limit()
## @brief Set Power Limit
## @param power_limit Power Limit
## @return Return Code
## @retval 0 Successfully Set Power Limit
## @retval 1 Failed to Set Power Limit
## @ingroup nvidia
#-------------------------------------------------------------------------------
preps::nvidia::set_power_limit() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local power_limit="${1}"
	if [[ -z "${power_limit}" ]]; then
		main::log_event -level "FATAL" -message "Missing Argument: [Power Limit]"
	fi
	if apis::nvsmi::set_power_limit -power_limit "${power_limit}"; then
		main::log_event -level "INFO" -message "Set Power Limit: [$(apis::nvsmi::get_power_limit)]"
	else
		main::log_event -level "ERROR" -message "Failed to Set Power Limit"
		rc=1
	fi
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
