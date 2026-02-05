#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::reset_gpu_clocks()
## @brief Reset GPU Clocks
## @return Return Code
## @retval 0 Successfully Reset Clocks
## @retval 1 Failed to Reset Clocks
## @ingroup nvidia
# ------------------------------------------------------------------------------
preps::nvidia::reset_gpu_clocks() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  [ -z $1 ] || main::log_event -level "INFO" -message "Invalid Option: [${1}]. Proceeding anyway."
  if apis::nvsmi::reset_gpu_clocks; then
    main::log_event -level "INFO" -message "Reset Clocks: [$(apis::nvsmi::get_gpu_clocks)]"
  else
    main::log_event -level "ERROR" -message "Failed to Reset Clocks: [$(apis::nvsmi::get_gpu_clocks)] - Return Code: [$?]"
    rc=1
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}
