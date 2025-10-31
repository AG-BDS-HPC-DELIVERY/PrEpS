#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::set_nvlink_bandwidth_mode()
## @brief Set NVLink Bandwidth Mode
## @param mode Bandwidth Mode: {3QUARTER|FULL|HALF|MIN|OFF}
## @return Return Code
## @retval 0 Successfully Set NVLink Bandwidth Mode
## @retval 1 Failed to Set NVLink Bandwidth Mode
## @ingroup nvidia
# ------------------------------------------------------------------------------
preps::nvidia::set_nvlink_bandwidth_mode() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local bandwidth_mode="${1}"
  [[ -n "${bandwidth_mode}" ]] ||
    { main::log_event -level "ERROR" -message "Missing Argument: [Bandwidth Mode]"; return 1; }
  [[ "${bandwidth_mode}" =~ (3QUARTER|FULL|HALF|MIN|OFF) ]] ||
    { main::log_event -level "ERROR" -message "Invalid Bandwidth Mode: [${bandwidth_mode}]"; return 1; }
  ${SUDO} ${NVSMI_EXECBIN} nvlink --setBandwidthMode "${bandwidth_mode}" &> /dev/null
  local -i rc=$?
  read -r bandwidth_mode < <(${NVSMI_EXECBIN} nvlink --getBandwidthMode | awk 'match($0, /GPU NVLINK bandwidth mode:\s+(.+)/, a) {print a[1]}')
  if (( rc == 0 )); then
    main::log_event -level "INFO" -message "Set NVLink Bandwidth Mode: [${bandwidth_mode}]"
  else
    main::log_event -level "ERROR" -message "Failed to Set NVLink Bandwidth Mode: [${bandwidth_mode}] - Return Code: [${rc}]"
  fi    
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${rc}"
  return ${rc:-0}
}