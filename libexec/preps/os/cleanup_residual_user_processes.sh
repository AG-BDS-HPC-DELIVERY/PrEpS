#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::os::cleanup_residual_user_processes()
## @brief Cleanup Residual User Processes
## @return Return Code
## @retval 0 Killed Residual User Processes
## @retval 1 Failed to Kill Residual User Processes
## @ingroup os
# ------------------------------------------------------------------------------
preps::os::cleanup_residual_user_processes() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  if (( SLURM_JOB_UID > 1000 )); then
    # 1st gentle pass
    if killall --signal SIGTERM --user "${SLURM_JOB_USER}"; then
      main::log_event -level "INFO" -message "Killed Residual User Processes for User: [${SLURM_JOB_USER}] via SIGTERM"
    fi
    # 2nd not so gentle pass
    if pgrep -u "${SLURM_JOB_USER}" > /dev/null; then
      # Some processes did not finish yet, give them the chance for 2 seconds
      sleep 2
      # Can't wait anymore, kill them
      if killall --signal SIGKILL --user "${SLURM_JOB_USER}"; then
        main::log_event -level "INFO" -message "Lingering processes after gentle termination: Killed Residual User Processes for User: [${SLURM_JOB_USER}] via SIGKILL"
      fi
    fi
    # If not all processes were successfully killed, report it
    if pgrep -u "${SLURM_JOB_USER}" > /dev/null; then
      main::log_event -level "INFO" -message "SIGTERM and SIGKILL did not kill all processes of user ${SLURM_JOB_USER} in time. Hoping health checks get that."
    fi
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]"
  return 0
}
