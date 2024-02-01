#!/usr/bin/env bash

preps::nvidia::check_register_files() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	if which nvidia-smi &>/dev/null; then
		local ecc_errors
		ecc_errors="$(nvidia-smi --format=csv,noheader --query-gpu=ecc.errors.corrected.aggregate.register_file 2>/dev/null | awk '{sum = sum + $1} END {print sum}')"
		if (( ecc_errors > 0 )); then
			main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "ECC Errors: [${ecc_errors}]"
			rc=1
		else
			main::log_event -level "${LOGGER_LEVEL_INFO}" -message "No ECC Error Found"
		fi
	else
		main::log_event -level "${LOGGER_LEVEL_WARN}" -message "No NVIDIA SMI Command Available"
	fi
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
