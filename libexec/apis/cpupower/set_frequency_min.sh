#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn apis::cpupower::set_frequency_min()
## @brief Set Min. CPU Frequency
## @param frequency_min Min. CPU Frequency
## @return Return Code
## @retval cpupower Command Return Code
## @ingroup cpupower
# ------------------------------------------------------------------------------
apis::cpupower::set_frequency_min() {
	while (( $# > 0 )); do
		case "${1}" in
			-frequency_min)
				local frequency_min="${2}"
				shift
				;;
			*)
				main::log_event -level "FATAL" -message "Invalid Option: [${1}]"
				;;
		esac
		shift
	done
	[[ -n "${frequency_min}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [Frequency Min.]"
	${SUDO} "${CPUPOWER_EXECBIN}" frequency-set --min "${frequency_min}" &>/dev/null
	return $?
}
