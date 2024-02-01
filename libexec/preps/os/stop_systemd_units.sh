#!/usr/bin/env bash

preps::os::stop_systemd_units() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local units && IFS="," read -a units -r <<<"${1}"
	if [[ -z "${units[*]}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [Units]"
	fi
	local unit
	for unit in "${units[@]}"; do
		${SUDO} systemctl stop "${unit}"
		(( rc = rc + $? ))
	done
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}