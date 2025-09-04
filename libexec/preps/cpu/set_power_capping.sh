#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::cpu::set_power_capping()
## @brief Set CPU Power Capping
## @param power_cap CPU Power Capping in Microwatts
## @return Return Code
## @retval 0 Successfully Set CPU Power Cap
## @retval 1 Failed to Set CPU Power Cap
## @ingroup cpu
# ------------------------------------------------------------------------------
preps::cpu::set_power_capping() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  local power_cap="${1}"
  [[ -n "${power_cap}" ]] ||
    { main::log_event -level "FATAL" -message "Missing Argument: [Power Cap]"; return ${rc}; }
  (( power_cap > 0 )) ||
    { main::log_event -level "FATAL" -message "Invalid Power Cap Value: [${power_cap}]"; return ${rc}; }
  for devicedir in /sys/class/hwmon/hwmon*/device; do
    if grep 'CPU Power Socket' "${devicedir}/power1_oem_info" &> /dev/null; then
      if echo ${power_cap} > "${devicedir}/power1_cap" 2> /dev/null; then
        main::log_event -level "INFO" -message "Set CPU Power Capping: [${power_cap}] (uW)"
      else
        main::log_event -level "ERROR" -message "Failed to Set CPU Power Capping - Return Code: [$?]"
        rc=1
      fi
    fi
  done
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}
