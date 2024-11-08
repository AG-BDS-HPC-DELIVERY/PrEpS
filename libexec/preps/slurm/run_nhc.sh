#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::slurm::run_nhc()
## @brief Run NHC
## @return Return Code
## @retval 0 Executed NHC without Error
## @retval 1 Executed NHC with Errors
## @ingroup slurm
#-------------------------------------------------------------------------------
preps::slurm::run_nhc() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  [[ -x "${NHC_EXECBIN}" ]] || main::log_event -level "FATAL" -message "Invalid NHC Executable: [${NHC_EXECBIN}]"
  if ${NHC_EXECBIN} &>/dev/null; then
	  main::log_event -level "INFO" -message "Executed NHC without Error"
  else
	  main::log_event -level "ERROR" -message "Executed NHC with Errors -> Return Code: [${?}]"
    rc=1
  fi
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return 0
}
