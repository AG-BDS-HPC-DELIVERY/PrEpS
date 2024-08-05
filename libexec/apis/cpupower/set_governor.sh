#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::cpupower::set_governor()
## @brief Set Governor
## @param governor Governor
## @return Return Code
## @retval cpupower Command Return Code
## @ingroup cpupower
#-------------------------------------------------------------------------------
apis::cpupower::set_governor() {
	while (( $# > 0 )); do
		case "${1}" in
			-governor)
				local governor="${2}"
				shift
				;;
			*)
				main::log_event -level "FATAL" -message "Invalid Option: [${1}]"
				;;
		esac
		shift
	done
	[[ -n "${governor}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [Governor]"
	${SUDO} "${CPUPOWER_EXECBIN}" frequency-set --governor "${governor}" &>/dev/null
	return $?
}
