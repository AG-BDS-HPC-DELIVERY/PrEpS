#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::check_applications_clocks()
## @brief Check Applications Clocks
## @return Return Code
## @retval 0 No Invalid Applications Clocks Found
## @retval 1 Invalid Applications Clocks Found
## @ingroup nvidia
# ------------------------------------------------------------------------------
preps::nvidia::check_applications_clocks() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  local applications_clocks="${1}"
  [[ -n "${applications_clocks}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [Applications Clocks]"
  local applications_clocks_1 applications_clocks_2
  if which nvidia-smi &>/dev/null; then
    applications_clocks_1="$(apis::nvsmi::get_applications_clocks)"
    for applications_clocks_2 in ${applications_clocks_1//${PREPS_MULTIPLE_VALUE_SEPARATOR}/ }; do
      [[ "${applications_clocks_2}" == "${applications_clocks}" ]] || { rc=1; break; }
    done
    if (( rc == 0 )); then
      main::log_event -level "INFO" -message "No Invalid Applications Clocks Found"
    else
      main::log_event -level "ERROR" -message "Invalid Applications Clocks Found: [${applications_clocks_1}] ( Expected: [${applications_clocks}] )"
    fi
  else
    main::log_event -level "WARN" -message "No NVIDIA SMI Command Available"
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
  return ${rc}
}
