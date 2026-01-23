#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::start_mps()
## @brief Start MPS
## @return Return Code
## @retval 0 Successfully Started MPS
## @retval 1 Failed to Start MPS
## @ingroup nvidia
# ------------------------------------------------------------------------------
preps::nvidia::start_mps() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  local cuda_mps="${1}"
  [[ -n "${cuda_mps}" ]] ||
    { main::log_event -level "FATAL" -message "Missing Argument: [CUDA_MPS]"; return ${rc}; }
  [[ "${cuda_mps}" =~ ^(1|0|y|n|yes|no|enable|disable)$ ]] ||
    { main::log_event -level "ERROR" -message "Invalid CUDA_MPS: [${cuda_mps}]"; return ${rc}; }
  if [[ "${cuda_mps}" =~ ^(1|y|yes|enable)$ ]];
  then
    if nvidia-cuda-mps-control -d &> /dev/null; then
      main::log_event -level "INFO" -message "Started NVIDIA CUDA MPS Control Daemon"
    else
      main::log_event -level "ERROR" -message "Failed to Start NVIDIA CUDA MPS Control Daemon - Return Code: [$?]"
    fi
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}
