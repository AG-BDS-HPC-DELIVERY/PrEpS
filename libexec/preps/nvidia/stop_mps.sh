#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::stop_mps()
## @brief Stop MPS
## @return Return Code
## @retval 0 Successfully Stopped MPS
## @retval 1 Failed to Stop MPS
## @ingroup nvidia
# ------------------------------------------------------------------------------
preps::nvidia::stop_mps() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	export CUDA_MPS_LOG_DIRECTORY="/tmp/nvidia-log_${CUDA_VISIBLE_DEVICES//,/}"
	export CUDA_MPS_PIPE_DIRECTORY="/tmp/nvidia-mps_${CUDA_VISIBLE_DEVICES//,/}"
	if pgrep --full "nvidia-cuda-mps" --uid "${SLURM_JOB_USER}" &>/dev/null; then
		echo quit | nvidia-cuda-mps-control
	fi
	if pgrep --full "nvidia-cuda-mps" --uid "${SLURM_JOB_USER}" &>/dev/null; then
		if killall --signal SIGKILL nvidia-cuda-mps-server &>/dev/null; then
			main::log_event -level "INFO" -message "Killed Residual CUDA MPS Server Processes"
		else
			main::log_event -level "ERROR" -message "Failed to Kill Residual CUDA MPS Server Processes - Return Code: [$?]"
			rc=1
		fi
	fi
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
