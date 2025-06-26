#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::thp::set_thp_shmem()
## @brief Set Transparent Huge Pages (THP) SHMEM
## @param thp Transparent Huge Pages SHMEM Configuration: {advise | always | deny | force | never | within_size}
## @return Return Code
## @retval 0 Successfully Set Transparent Huge Pages SHMEM
## @retval 1 Failed to Set Transparent Huge Pages SHMEM
## @ingroup thp
# ------------------------------------------------------------------------------
preps::thp::set_thp_shmem() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -r thp_shmem_enabled="/sys/kernel/mm/transparent_hugepage/shmem_enabled"
  local -i rc=0
  local thp_shmem="${1}"
  [[ -n "${thp_shmem}" ]] ||
    { main::log_event -level "ERROR" -message "Missing Argument: [THP shmem]"; return ${rc}; }
  [[ "${thp_shmem}" =~ ^(advise|always|deny|force|never|within_size)$ ]] ||
    { main::log_event -level "ERROR" -message "Invalid THP Shmem: [${thp_shmem}]"; return ${rc}; }
  if ${SUDO} /bin/bash -c "echo ${thp_shmem} >${thp_shmem_enabled}" &> /dev/null; then
    main::log_event -level "INFO" -message "Set Transparent Huge Pages (THP) for Shmem: [$(cat ${thp_shmem_enabled})]"
  else
    main::log_event -level "ERROR" -message "Failed to Set Transparent Huge Pages (THP) for Shmem: [$(cat ${thp_shmem_enabled})]"
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}
