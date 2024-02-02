#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::os::start_failed_systemd_units()
## @brief Start Failed systemd Units
## @return Return Code
## @retval 0 Successfully Restarted Failed systemd Units
## @retval 1 Failed to Restart Failed systemd Units
## @ingroup os
#-------------------------------------------------------------------------------
preps::os::start_failed_systemd_units() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local services
	readarray -r -t services < <(systemctl list-units --no-legend --no-pager --state=failed --type=service | awk '{print $1}')
	if (( ${#services[@]} > 0 )); then
		local service
		for service in "${services[@]}"; do
			if ${SUDO} systemctl restart "${service}" &>/dev/null; then
				main::log_event -level "${LOGGER_LEVEL_WARN}" -message "Restarted Service: [${service}]"
			else
				main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed Restarting Service: [${service}]"
			fi
		done
	fi
	readarray -r -t services < <(systemctl list-units --no-legend --no-pager --state=failed --type=service | awk '{print $1}')
	if (( ${#services[@]} > 0 )); then
		main::log_event -level "${LOGGER_LEVEL_WARN}" -message "Failed Services - Total Count: [${#services[@]}]"
		rc=1
	else
		main::log_event -level "${LOGGER_LEVEL_INFO}" -message "No Service in Failed State"
	fi
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
