#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::memory::set_numa_balancing()
## @brief Set NUMA Balancing
## @param balancing NUMA Balancing: {0 | 1}
## @return Return Code
## @retval 0 Successfully Set NUMA Balancing
## @retval 1 Failed to Set NUMA Balancing
## @ingroup memory
# ------------------------------------------------------------------------------
preps::memory::set_numa_balancing() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  local balancing="${1}"
  [[ -n "${balancing}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [NUMA Balancing]"
  (( balancing == 0 || balancing == 1 )) || main::log_event -level "FATAL" -message "Invalid NUMA Balancing Value: [${balancing}]"
  echo "${balancing}" >"/proc/sys/kernel/numa_balancing" || \
    { main::log_event -level "ERROR" -message "Failed to Set NUMA Balancing"; rc=1; } 
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
  return ${rc}
}
