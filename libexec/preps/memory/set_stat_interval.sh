#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::memory::set_stat_interval()
## @brief Set Statistics Interval
## @param interval Statistics Interval in Seconds
## @return Return Code
## @retval 0 Set Statistics Interval
## @retval 1 Failed to Statistics Interval
## @ingroup memory
# ------------------------------------------------------------------------------
preps::memory::set_stat_interval() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  local -i interval=${1}
  (( interval > 0 )) ||
    { main::log_event -level "ERROR" -message "Invalid Statistics Interval Value: [${interval}]"; return ${rc}; }
  if ${SUDO} /sbin/sysctl vm.stat_interval=${interval} &> /dev/null; then
    main::log_event -level "INFO" -message "Set Statistics Interval: [${interval}]"
  else
    main::log_event -level "ERROR" -message "Failed to Set Statistics Interval - Return Code: [$?]"
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}
