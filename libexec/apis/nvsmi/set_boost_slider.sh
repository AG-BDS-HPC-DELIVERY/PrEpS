#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::nvsmi::set_boost_slider()
## @brief Set Boost Slider
## @param vboost Video Boost Slider
## @param id GPU ID
## @return Return Code
## @retval NVIDIA SMI Command Return Code
## @ingroup nvsmi
#-------------------------------------------------------------------------------
apis::nvsmi::set_boost_slider() {
	while (( $# > 0 )); do
		case "${1}" in
			-vboost)
				local vboost="${2}"
				shift
				;;
			*)
				main::log_event -level "FATAL" -message "Invalid Option: [${1}]"
				;;
		esac
		shift
	done
	if [[ -z "${vboost}" ]]; then
		main::log_event -level "FATAL" -message "Missing Argument: [Video Boost Slider]"
	fi
	if (( vboost != 0 )) && (( vboost != 1 )); then
		main::log_event -level "FATAL" -message "Invalid Video Boost Slider: [${vboost}]"
	fi
	${SUDO} "${NVSMI_EXECBIN}" boost-slider --vboost "${vboost}"
	return $?
}
