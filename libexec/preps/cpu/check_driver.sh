#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::cpu::check_driver()
## @brief Check cpufreq Driver
## @param num_cpus Total Number of CPUs
## @return Return Code
## @retval 0 cpufreq Driver is Operational
## @retval 1 cpufreq Driver is Dysfunctional
## @ingroup cpu
# ------------------------------------------------------------------------------
preps::cpu::check_driver() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  local num_cpus="${1}"
  [[ -n "${num_cpus}" ]] ||
    { main::log_event -level "ERROR" -message "Missing Argument: [Number of CPUs]"; return ${rc}; }
  (( num_cpus > 0 )) ||
    { main::log_event -level "ERROR" -message "Invalid Number of CPUs: [${num_cpus}]"; return ${rc}; }
  count=$(find /sys/devices/system/cpu/ -maxdepth 1 -mindepth 1 -regex "/sys/devices/system/cpu/cpu[0-9]+" | wc -l)
  (( count == num_cpus )) || \
    { main::log_event -level "ERROR" -message "Invalid Number of Visible CPUs - cpufreq Driver Must Be Dysfunctional"; rc=1; } 
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}
