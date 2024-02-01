#!/usr/bin/env bash

preps::tuned::enable_profile() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -r tuned_execbin="/usr/sbin/tuned-adm"
	local -i rc=0
	local profile="${1}"
	if [[ -z "${profile}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [Profile]"
	fi
	if "${tuned_execbin}" profile "${profile}" &>/dev/null; then
		main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Enabled tuned Profile: [${profile}]"
	else
		main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed to Enable tuned Profile: [${profile}]"
		rc=1
	fi
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
