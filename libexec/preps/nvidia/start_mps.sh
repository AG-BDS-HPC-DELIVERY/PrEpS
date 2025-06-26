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
  export CUDA_MPS_LOG_DIRECTORY="/tmp/nvidia-log_${CUDA_VISIBLE_DEVICES//,/}"
  export CUDA_MPS_PIPE_DIRECTORY="/tmp/nvidia-mps_${CUDA_VISIBLE_DEVICES//,/}"
  if nvidia-cuda-mps-control -d &> /dev/null; then
    main::log_event -level "INFO" -message "Started NVIDIA CUDA MPS Control Daemon"
  else
    main::log_event -level "ERROR" -message "Failed to Start NVIDIA CUDA MPS Control Daemon - Return Code: [$?]"
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}
