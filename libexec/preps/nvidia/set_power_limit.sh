#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::set_power_limit()
## @brief Set GPU/Module Power Limit
## @param power_limits Power Limits: GPU,Module
## @return Return Code
## @retval 0 Successfully Set Power Limit
## @retval 1 Failed to Set Power Limit
## @ingroup nvidia
# ------------------------------------------------------------------------------
preps::nvidia::set_power_limit() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  local scope=("GPU" "Module")
  local power_limits && IFS="," read -a power_limits -r <<<"${1}"
  [[ -n "${power_limits}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [Power Limits]"
  local -i index
  for index in 1 0; do
    (( ${power_limits[index]} > 0 )) || main::log_event -level "FATAL" -message "Invalid Power Limit Value: [${power_limits[index]}] for Scope: [${index}/${scope[index]}]"
  done
  (( ${power_limits[1]} >= ${power_limits[0]} )) ||
    main::log_event -level "FATAL" -message "Power Limit: [${power_limits[1]}] for Scope: [1/${scope[1]}] Must Be Greater or Equal than Power Limit: [${power_limits[0]}] for Scope: [0/${scope[0]}]"
  for index in 1 0; do
    if apis::nvsmi::set_power_limit -power_limit "${power_limits[index]}" -scope "${index}"; then
      main::log_event -level "INFO" -message "Set Power Limit: [$(apis::nvsmi::get_current_power_limit -scope ${index})] for Scope: [${index}/${scope[index]}]"
    else
      main::log_event -level "ERROR" -message "Failed to Set Power Limit for Scope: [${index}/${scope[index]}] - Return Code: [$?]"
      rc=1
    fi
  done
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
  return ${rc}
}
