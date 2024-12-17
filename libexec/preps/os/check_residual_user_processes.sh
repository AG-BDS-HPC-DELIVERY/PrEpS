#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::os::check_residual_user_processes()
## @brief Check Residual User Processes
## @return Return Code
## @retval 0 No Residual User Processes Found
## @retval 1 Residual User Processes Found
## @ingroup os
# ------------------------------------------------------------------------------
preps::os::check_residual_user_processes() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  if [[ "${SLURM_JOB_USER}" != "root" ]]; then
    local processes
    readarray -r -t processes < <(pgrep --euid "${SLURM_JOB_USER}" --list-full --parent 1 2>/dev/null | awk '!/nvidia-cuda-mps-control/')
    if (( ${#processes[@]} > 0 )); then
      main::log_event -level "ERROR" -message "Residual User Processes Found - Total Count: [${#processes[@]}] - First Process: [${processes[0]}]"
      rc=1
    else
      main::log_event -level "INFO" -message "No Residual User Process Found"
    fi
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
  return ${rc}
}
