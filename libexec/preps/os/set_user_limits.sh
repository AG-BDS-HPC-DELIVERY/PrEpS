#!/usr/bin/env bash

preps::os::set_user_limits() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local limits && IFS="," read -a limits -r <<<"${1}"
	if [[ -z "${limits[*]}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [Limits]"
	fi
	local limit
	for limit in "${limits[@]}"; do
		local option value
        IFS="=" read -r option value <<<"${limit}"
        if [[ -z "${option}" ]] || [[ -z "${value}" ]]; then
	    	main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Failed to Parse Limit: [${limit}]"
        fi
        main::log_event -level "${LOGGER_LEVEL_DEBUG}" -message "ulimit -${option} ${value}"
		#(( rc = rc + $? ))
	done
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}