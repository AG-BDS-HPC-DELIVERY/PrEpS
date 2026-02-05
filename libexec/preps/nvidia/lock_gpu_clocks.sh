#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::lock_gpu_clocks()
## @brief Lock GPU Clocks
## @param clocks GPU Clocks: MIN_GPU_CLOCK,MAX_GPU_CLOCK
## @param mode Mode: 0=UNLOCKED, 1=LOCKED
## @return Return Code
## @retval 0 Successfully Set Clocks
## @retval 1 Failed to Set Clocks
## @ingroup nvidia
# ------------------------------------------------------------------------------
preps::nvidia::lock_gpu_clocks() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  local clocks="${1}"
  local -i mode=${2:-0}
  [[ -n "${clocks}" ]] ||
    { main::log_event -level "ERROR" -message "Missing Argument: [Clocks]"; return 1; }
  (( mode == 0 || mode == 1 )) ||
    { main::log_event -level "ERROR" -message "Invalid Locking Mode: [${mode}]"; return 1; }
  if apis::nvsmi::lock_gpu_clocks -clocks "${clocks}" -mode "${mode}"; then
    main::log_event -level "INFO" -message "Set Clocks: [$(apis::nvsmi::get_gpu_clocks)]"
  else
    main::log_event -level "ERROR" -message "Failed to Set Clocks: [$(apis::nvsmi::get_gpu_clocks)] - Return Code: [$?]"
    rc=1
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}
