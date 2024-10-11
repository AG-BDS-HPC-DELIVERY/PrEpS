#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::cleanup_mps_processes()
## @brief Cleanup MPS Processes
## @return Return Code
## @retval 0 MPS Processes Have Been Successfully Cleaned Up
## @retval 1 MPS Processes Could Not Be Cleaned Up
## @ingroup nvidia
#-------------------------------------------------------------------------------
preps::nvidia::cleanup_mps_processes() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	# MPS Processes
	if pgrep -f "nvidia-cuda-mps" &>/dev/null; then
		echo quit | nvidia-cuda-mps-control
		main::log_event -level "INFO" -message "Stopped CUDA MPS Servers"
	fi
	# MPS Zombie Processes
	if pgrep -f "nvidia-cuda-mps" &>/dev/null; then
		if killall --signal SIGKILL nvidia-cuda-mps-server &>/dev/null; then
			main::log_event -level "INFO" -message "Killed Residual CUDA MPS Servers Processes"
		fi
	fi
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
