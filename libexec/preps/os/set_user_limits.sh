#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::os::set_user_limits()
## @brief Set User Limits
## @param limits Comma-Separated List of User Limits: limit=value[,limit=value]
## @return Return Code
## @retval 0 Successfully Set User Limits
## @retval 1 Failed to Set User Limits
## @ingroup os
# ------------------------------------------------------------------------------
preps::os::set_user_limits() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  local limits && IFS="," read -a limits -r <<<"${1}"
  [[ -n "${limits[*]}" ]] ||
    { main::log_event -level "ERROR" -message "Missing Argument: [Limits]"; return ${rc}; }
  local limit
  for limit in "${limits[@]}"; do
    local option value
    IFS="=" read -r option value <<<"${limit}"
    if [[ -z "${option}" ]] || [[ -z "${value}" ]]; then
      main::log_event -level "ERROR" -message "Failed to Parse Limit: [${limit}]"
    fi
    main::log_event -level "DEBUG" -message "ulimit -${option} ${value}"
  done
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}