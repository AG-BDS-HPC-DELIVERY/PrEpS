#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::set_applications_clocks()
## @brief Set Applications Clocks
## @param applications_clocks Applications Clocks: MEMORY,GRAPHICS
## @return Return Code
## @retval 0 Successfully Set Applications Clocks
## @retval 1 Failed to Set Applications Clocks
## @ingroup nvidia
# ------------------------------------------------------------------------------
preps::nvidia::set_applications_clocks() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  local applications_clocks="${1}"
  [[ -n "${applications_clocks}" ]] ||
    { main::log_event -level "ERROR" -message "Missing Argument: [Applications Clocks]"; return ${rc}; }
  if apis::nvsmi::set_applications_clocks -applications_clocks "${applications_clocks}"; then
    main::log_event -level "INFO" -message "Set Applications Clocks: [$(apis::nvsmi::get_applications_clocks)]"
  else
    main::log_event -level "ERROR" -message "Failed to Set Applications Clocks: [$(apis::nvsmi::get_applications_clocks)] - Return Code: [$?]"
    rc=1
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}
