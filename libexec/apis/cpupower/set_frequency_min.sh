#!/usr/bin/env bash

apis::cpupower::set_frequency_min() {
	while (( $# > 0 )); do
		case "${1}" in
			-frequency-min)
				local frequency_min="${2}"
				shift
				;;
			*)
				main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Invalid Option: [${1}]"
				;;
		esac
		shift
	done
	if [[ -z "${frequency_min}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [Frequency Min.]"
	fi
	${SUDO} "${CPUPOWER_EXECBIN}" frequency-set --min "${frequency_min}" &>/dev/null
	return $?
}
