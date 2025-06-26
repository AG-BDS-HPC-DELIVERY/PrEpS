#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::run_dcgm_diag()
## @brief Run DCGM Diagnostics
## @param diag Diagnostics Level
## @return Return Code
## @retval 0 DCGM Diagnostics Passed
## @retval 1 DCGM Diagnostics Failed
## @ingroup nvidia
# ------------------------------------------------------------------------------
preps::nvidia::run_dcgm_diag() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -r DCGMI_EXECBIN="dcgmi"
  local -i rc=0
  local diag="${1}"
  [[ -n "${diag}" ]] ||
    { main::log_event -level "ERROR" -message "Missing Argument: [DCGM Diagnostics Level]"; return ${rc}; }
  (( diag >= 1 && diag <= 4 )) ||
    { main::log_event -level "ERROR" -message "Invalid DCGM Diagnostics Level: [${diag}]"; return ${rc}; }
  if "${DCGMI_EXECBIN}" diag --run "${diag}" &> /dev/null; then
    main::log_event -level "INFO" -message "Passed DCGM Diagnostics with Level: [${diag}]"
  else
    main::log_event -level "ERROR" -message "Failed DCGM Diagnostics with Level: [${diag}] - Return Code: [$?]"
    rc=1
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}
