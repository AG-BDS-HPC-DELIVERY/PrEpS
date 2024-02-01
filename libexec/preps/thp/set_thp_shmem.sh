#!/usr/bin/env bash

preps::thp::set_thp_shmem() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -r thp_shmem_enabled="/sys/kernel/mm/transparent_hugepage/shmem_enabled"
	local -i rc=0
	local thp_shmem="${1}"
	if [[ -z "${thp_shmem}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [THP shmem]"
	fi
	if [[ "${thp_shmem}" != "always" && "${thp_shmem}" != "advise" && "${thp_shmem}" != "never" && ${thp_shmem} != "deny" && ${thp_shmem} != "force" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Invalid THP Shmem: [${thp_shmem}]"
	fi
	if ${SUDO} /bin/bash -c "echo ${thp_shmem} >${thp_shmem_enabled}" &>/dev/null; then
		main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Set Transparent Huge Pages (THP) for Shmem: [${thp_shmem}]"
		main::log_event -level "${LOGGER_LEVEL_DEBUG}" -message "Transparent Huge Pages (THP) for Shmem Configuration: [$(cat ${thp_shmem_enabled})]"
	else
		main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed to Set Transparent Huge Pages for Shmem: [${thp_shmem}]"
		rc=1
	fi
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
