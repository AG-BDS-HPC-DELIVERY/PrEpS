#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::cpufreq::set_governor()
## @brief Set CPU Power Governor
## @param governor CPU Power Governor: {conservative | ondemand | performance | powersave | userspace}
## @return Return Code
## @retval 0 Successfully Set CPU Power Governor
## @retval 1 Failed to Set CPU Power Governor
## @ingroup cpufreq
#-------------------------------------------------------------------------------
preps::cpufreq::set_governor() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local governor="${1}"
	[[ -n "${governor}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [Governor]"
	[[ "${governor}" == "conservative" \
		|| "${governor}" == "ondemand" \
		|| "${governor}" == "performance" \
		|| "${governor}" == "powersave" \
		|| "${governor}" == "userspace" ]] || main::log_event -level "FATAL" -message "Invalid Governor Value: [${governor}]"
	if [[ "$(apis::cpupower::get_governor)" != "${governor}" ]]; then
		if apis::cpupower::set_governor -governor "${governor}"; then
			main::log_event -level "INFO" -message "Set CPU Governor: [$(apis::cpupower::get_governor)]"
		else
			main::log_event -level "ERROR" -message "Failed to Set CPU Governor - Return Code: [$?]"
			rc=1
		fi
	else
		main::log_event -level "INFO" -message "Skipped Setting of CPU Governor"
	fi
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
