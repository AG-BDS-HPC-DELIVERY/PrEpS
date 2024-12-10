#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn apis::nvsmi::get_current_power_limit()
## @brief Get Current Power Limit
## @param id GPU ID
## @return Return Code
## @retval 0
## @ingroup nvsmi
# ------------------------------------------------------------------------------
apis::nvsmi::get_current_power_limit() {
	while (( $# > 0 )); do
		case "${1}" in
			-id)
				local id="${2}"
				shift
				;;
			*)
				main::log_event -level "FATAL" -message "Invalid Option: [${1}]"
				;;
		esac
		shift
	done
	local power_limits1 power_limits2
	while read -r -u 9 power_limits1; do
		power_limits2="${power_limits2}${power_limits2:+";"}${power_limits1// /}"
	done 9< <("${NVSMI_EXECBIN}" --display="POWER" ${id:+--id="${id}"} --query \
		| awk '/Module Power Readings/,/Max Power Limit/' \
		| awk 'match($0, /Current Power Limit\s+:\s+([.0-9]+)\s+W$/, a) {print a[1]}')
	printf "%s" "${power_limits2}"
	return 0
}
