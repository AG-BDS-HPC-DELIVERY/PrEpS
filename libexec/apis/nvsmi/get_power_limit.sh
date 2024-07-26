#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::nvsmi::get_power_limit()
## @brief Get Power Limit
## @return Return Code
## @retval 0
## @ingroup nvsmi
#-------------------------------------------------------------------------------
apis::nvsmi::get_power_limit() {
	while (( $# > 0 )); do
		case "${1}" in
			*)
				main::log_event -level "FATAL" -message "Invalid Option: [${1}]"
				;;
		esac
		shift
	done
	local power_limit power_limits
	while read -r power_limit; do
		power_limit="${power_limit// /}"
		power_limits="${power_limits}${power_limits:+" | "}${power_limit}"
	done < <("${NVSMI_EXECBIN}" --format="csv,noheader,nounits" --query-gpu="enforced.power.limit")
	printf "%s" "${power_limits}"
	return 0
}
