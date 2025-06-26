#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::slurm::run_nhc()
## @brief Run NHC
## @return Return Code
## @retval 0 Executed NHC Successfully
## @retval 1 Executed NHC with Failed Checks
## @ingroup slurm
# ------------------------------------------------------------------------------
preps::slurm::run_nhc() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  if [[ -x "${NHC_EXECBIN}" ]]; then
    if ${NHC_EXECBIN} &> /dev/null; then
      main::log_event -level "INFO" -message "Executed NHC Successfully"
    else
      main::log_event -level "ERROR" -message "Executed NHC with Failures" -rc "${?}"
    fi
  else
    main::log_event -level "ERROR" -message "Invalid NHC Executable: [${NHC_EXECBIN}]"
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}
