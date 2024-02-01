#!/usr/bin/env bash

apis::nvsmi::reset_applications_clocks() {
	while (( $# > 0 )); do
		case "${1}" in
			-id)
				local id="${2}"
				shift
				;;
			*)
				main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Invalid Option: [${1}]"
				;;
		esac
		shift
	done
	if [[ -z "${id}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [ID]"
	fi
	${SUDO} "${NVSMI_EXECBIN}" --id="${id}" --reset-applications-clocks
	return $?
}
