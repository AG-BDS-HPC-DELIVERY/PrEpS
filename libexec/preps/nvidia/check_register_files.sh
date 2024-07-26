#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::check_register_files()
## @brief Check Register Files
## @return Return Code
## @retval 0 No ECC Error Found
## @retval 1 ECC Errors Found
## @ingroup nvidia
#-------------------------------------------------------------------------------
preps::nvidia::check_register_files() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	if which nvidia-smi &>/dev/null; then
		local ecc_errors
		ecc_errors="$(nvidia-smi --format=csv,noheader --query-gpu=ecc.errors.corrected.aggregate.register_file 2>/dev/null | awk '{sum = sum + $1} END {print sum}')"
		if (( ecc_errors > 0 )); then
			main::log_event -level "ERROR" -message "ECC Errors: [${ecc_errors}]"
			rc=1
		else
			main::log_event -level "INFO" -message "No ECC Error Found"
		fi
	else
		main::log_event -level "WARN" -message "No NVIDIA SMI Command Available"
	fi
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
