#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::thp::set_thp()
## @brief Set Transparent Huge Pages (THP)
## @param thp Transparent Huge Pages Configuration: {always | madvise | never}
## @return Return Code
## @retval 0 Successfully Set Transparent Huge Pages
## @retval 1 Failed to Set Transparent Huge Pages
## @ingroup thp
# ------------------------------------------------------------------------------
preps::thp::set_thp() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -r thp_enabled="/sys/kernel/mm/transparent_hugepage/enabled"
  local -i rc=0
  local thp="${1}"
  [[ -n "${thp}" ]] ||
    { main::log_event -level "FATAL" -message "Missing Argument: [THP]"; return ${rc}; }
  [[ "${thp}" =~ ^(always|madvise|never)$ ]] ||
    { main::log_event -level "ERROR" -message "Invalid THP: [${thp}]"; return ${rc}; }
  if ${SUDO} /bin/bash -c "echo ${thp} >${thp_enabled}" &> /dev/null; then
    main::log_event -level "INFO" -message "Set Transparent Huge Pages (THP): [$(cat ${thp_enabled})]"
  else
    main::log_event -level "ERROR" -message "Failed to Set Transparent Huge Pages (THP): [$(cat ${thp_enabled})]"
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}
