#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::set_persistence_mode()
## @brief Set Persistence Mode
## @param mode Persistence Mode
## @return Return Code
## @retval 0 Successfully Set Persistence Mode
## @retval 1 Failed to Set Persistence Mode
## @ingroup nvidia
#-------------------------------------------------------------------------------
preps::nvidia::set_persistence_mode() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local mode="${1}"
	if [[ -z "${mode}" ]]; then
		main::log_event -level "FATAL" -message "Missing Argument: [Persistence Mode]"
	fi
    if ${NVSMI_EXECBIN} --persistence-mode "${mode}" &>/dev/null; then
		main::log_event -level "INFO" -message "Set Persistence Mode: [${mode}]"
	else
		main::log_event -level "ERROR" -message "Failed to Set Persistence Mode: [${mode}] - Return Code: [$?]"
		rc=1
	fi
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}

