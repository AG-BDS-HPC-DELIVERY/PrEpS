#!/usr/bin/env bash

preps::os::check_residual_user_processes() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	if [[ "${SLURM_JOB_USER}" != "root" ]]; then
		local processes
		readarray -r -t processes < <(pgrep --euid "${SLURM_JOB_USER}" --list-full --parent 1 2>/dev/null | awk '!/nvidia-cuda-mps-control/')
		if (( ${#processes[@]} > 0 )); then
			main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Residual User Processes Found - Total Count: [${#processes[@]}] - First Process: [${processes[0]}]"
			rc=1
		else
			main::log_event -level "${LOGGER_LEVEL_INFO}" -message "No Residual User Process Found"
		fi
	fi
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
