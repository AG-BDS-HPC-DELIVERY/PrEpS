#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn apis::nvsmi::reset_gpu_clocks()
## @brief Reset GPU Clocks
## @return Return Code
## @retval NVIDIA SMI Command Return Code
## @ingroup nvsmi
# ------------------------------------------------------------------------------
apis::nvsmi::reset_gpu_clocks() {
  [ -z $1 ] || main::log_event -level "INFO" -message "Invalid Option: [${1}]. Resetting anyway."
  ${SUDO} "${NVSMI_EXECBIN}" --reset-gpu-clocks &> /dev/null
  return $?
}
