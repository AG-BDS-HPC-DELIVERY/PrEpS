#!/usr/bin/env bash

apis::cpupower::set_frequency_max() {
	while (( $# > 0 )); do
		case "${1}" in
			-frequency-max)
				local frequency_max="${2}"
				shift
				;;
			*)
				main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Invalid Option: [${1}]"
				;;
		esac
		shift
	done
	if [[ -z "${frequency_max}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [Frequency Max.]"
	fi
	${SUDO} "${CPUPOWER_EXECBIN}" frequency-set --max "${frequency_max}" &>/dev/null
	return $?
}
