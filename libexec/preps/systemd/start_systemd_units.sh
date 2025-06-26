#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::systemd::start_systemd_units()
## @brief Start systemd Units
## @param units Comma-Separated List of systemd Units: unit[,unit]
## @return Return Code
## @retval 0 Successfully Started systemd Units
## @retval 1 Failed to Start systemd Units
## @ingroup systemd
# ------------------------------------------------------------------------------
preps::systemd::start_systemd_units() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  local units && IFS="," read -a units -r <<<"${1}"
  [[ -n "${units[*]}" ]] ||
    { main::log_event -level "ERROR" -message "Missing Argument: [Units]"; return ${rc}; }
  local unit
  for unit in "${units[@]}"; do
    if ${SUDO} systemctl start "${unit}" & >/dev/null; then
      main::log_event -level "INFO" -message "Started systemd Unit: [${unit}]"
    else
      main::log_event -level "ERROR" -message "Failed to Start systemd Unit: [${unit}] - Return Code: [$?]"
    fi
  done
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}