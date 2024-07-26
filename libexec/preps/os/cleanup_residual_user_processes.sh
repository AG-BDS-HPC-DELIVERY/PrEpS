#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::os::cleanup_residual_user_processes()
## @brief Cleanup Residual User Processes
## @return Return Code
## @retval 0 Killed Residual User Processes
## @retval 1 Failed to Kill Residual User Processes
## @ingroup os
#-------------------------------------------------------------------------------
preps::os::cleanup_residual_user_processes() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	if (( SLURM_JOB_UID > 1000 )); then
		# 1st Pass
		if killall --signal SIGKILL --user "${SLURM_JOB_USER}"; then
			main::log_event -level "INFO" -message "Killed Residual User Processes for User: [${SLURM_JOB_USER}]"
		fi
		# 2nd Pass
		local pid
		while read -r -u 9 pid; do
			if kill --signal SIGKILL "${pid}"; then
				main::log_event -level "INFO" -message "Killed Residual User Process: [${pid}]"
			fi
		done 9< <(pgrep -u "${SLURM_JOB_USER}" 2>/dev/null | xargs)
	fi
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]"
	return 0
}
