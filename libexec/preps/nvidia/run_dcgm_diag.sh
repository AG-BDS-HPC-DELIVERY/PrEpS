#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::run_dcgm_diag()
## @brief Run DCGM Diagnostics
## @param diag Diagnostics Level
## @return Return Code
## @retval 0 DCGM Diagnostics Passed
## @retval 1 DCGM Diagnostics Failed
## @ingroup nvidia
#-------------------------------------------------------------------------------
preps::nvidia::run_dcgm_diag() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local -r DCGMI_EXECBIN="dcgmi"
	local -i rc=0
	local diag="${1}"
	if [[ -z "${diag}" ]]; then
		main::log_event -level "FATAL" -message "Missing Argument: [DCGMI Diag Level]"
	fi
	if (( diag != 1 )) && (( diag != 2 )) && (( diag != 3 )) && (( diag != 4 )); then
		main::log_event -level "FATAL" -message "Invalid DCGMI Diag Level: [${diag}]"
	fi
	if "${DCGMI_EXECBIN}" diag --run "${diag}" &>/dev/null; then
		main::log_event -level "INFO" -message "DCGMI Diag with Level: [${diag}] Passed"
	else
		main::log_event -level "ERROR" -message "DCGMI Diag with Level: [${diag}] Failed - Return Code: [$?]"
		rc=1
	fi
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
