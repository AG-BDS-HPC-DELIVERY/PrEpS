#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::thp::set_thp_shmem()
## @brief Set Transparent Huge Pages (THP) SHMEM
## @param thp Transparent Huge Pages SHMEM Configuration
## @return Return Code
## @retval 0 Successfully Set Transparent Huge Pages SHMEM
## @retval 1 Failed to Set Transparent Huge Pages SHMEM
## @ingroup thp
#-------------------------------------------------------------------------------
preps::thp::set_thp_shmem() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local -r thp_shmem_enabled="/sys/kernel/mm/transparent_hugepage/shmem_enabled"
	local -i rc=0
	local thp_shmem="${1}"
	if [[ -z "${thp_shmem}" ]]; then
		main::log_event -level "FATAL" -message "Missing Argument: [THP shmem]"
	fi
	if [[ "${thp_shmem}" != "always" && "${thp_shmem}" != "advise" && "${thp_shmem}" != "never" && ${thp_shmem} != "deny" && ${thp_shmem} != "force" ]]; then
		main::log_event -level "FATAL" -message "Invalid THP Shmem: [${thp_shmem}]"
	fi
	if ${SUDO} /bin/bash -c "echo ${thp_shmem} >${thp_shmem_enabled}" &>/dev/null; then
		main::log_event -level "INFO" -message "Set Transparent Huge Pages (THP) for Shmem: [$(cat ${thp_shmem_enabled})]"
	else
		main::log_event -level "ERROR" -message "Failed to Set Transparent Huge Pages (THP) for Shmem: [$(cat ${thp_shmem_enabled})]"
		rc=1
	fi
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
