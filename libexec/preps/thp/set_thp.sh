#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::thp::set_thp()
## @brief Set Transparent Huge Pages (THP)
## @param thp Transparent Huge Pages Configuration
## @return Return Code
## @retval 0 Successfully Set Transparent Huge Pages
## @retval 1 Failed to Set Transparent Huge Pages
## @ingroup thp
#-------------------------------------------------------------------------------
preps::thp::set_thp() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -r thp_enabled="/sys/kernel/mm/transparent_hugepage/enabled"
	local -i rc=0
	local thp="${1}"
	if [[ -z "${thp}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [THP]"
	fi
	if [[ "${thp}" != "always" && "${thp}" != "madvise" && "${thp}" != "never" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Invalid THP: [${thp}]"
	fi
	if ${SUDO} /bin/bash -c "echo ${thp} >${thp_enabled}" &>/dev/null; then
		main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Set Transparent Huge Pages (THP): [${thp}]"
		main::log_event -level "${LOGGER_LEVEL_DEBUG}" -message "Transparent Huge Pages (THP) Configuration: [$(cat ${thp_enabled})]"
	else
		main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed to Set Transparent Huge Pages: [${thp}]"
		rc=1
	fi
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
