#!/usr/bin/env bash

preps::nvidia::check_pending_retirements() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	if which nvidia-smi &>/dev/null; then
		if (nvidia-smi --format=csv,noheader --query-gpu=retired_pages.pending 2>/dev/null | grep 'Yes' &>/dev/null); then
			main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Pending Retirements Found"
			rc=1
		else
			main::log_event -level "${LOGGER_LEVEL_INFO}" -message "No Pending Retirement Found"
		fi
	else
		main::log_event -level "${LOGGER_LEVEL_WARN}" -message "No NVIDIA SMI Command Available"
	fi
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
