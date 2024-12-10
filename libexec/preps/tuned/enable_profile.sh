#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::tuned::enable_profile()
## @brief Enable tuned Profile
## @param profile tuned Profile
## @return Return Code
## @retval 0 Successfully Enabled tuned Profile
## @retval 1 Failed to Enable tuned Profile
## @ingroup tuned
# ------------------------------------------------------------------------------
preps::tuned::enable_profile() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local -r tuned_execbin="/usr/sbin/tuned-adm"
	local -i rc=0
	local profile="${1}"
	[[ -n "${profile}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [Profile]"
	if "${tuned_execbin}" profile "${profile}" &>/dev/null; then
		main::log_event -level "INFO" -message "Enabled tuned Profile: [${profile}]"
	else
		main::log_event -level "ERROR" -message "Failed to Enable tuned Profile: [${profile}]"
		rc=1
	fi
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
