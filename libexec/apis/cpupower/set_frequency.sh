#!/usr/bin/env bash

apis::cpupower::set_frequency() {
	while (( $# > 0 )); do
		case "${1}" in
			-frequency)
				local frequency="${2}"
				shift
				;;
			*)
				main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Invalid Option: [${1}]"
				;;
		esac
		shift
	done
	if [[ -z "${frequency}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [Frequency]"
	fi
	${SUDO} "${CPUPOWER_EXECBIN}" frequency-set --freq "${frequency}" &>/dev/null
	return 0
}
