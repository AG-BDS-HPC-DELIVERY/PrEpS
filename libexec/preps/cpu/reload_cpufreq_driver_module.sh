#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::cpu::reload_cpufreq_driver_module()
## @brief Reload cpufreq Driver Module
## @param module Kernel Module
## @param systemd_unit systemd Unit
## @param max_active_time Maximum Active Time (Unit: Seconds)
## @return Return Code
## @retval 0 Driver Module Has Been Successfully Reloaded
## @retval 1 Driver Module Could Not Be Reloaded
## @ingroup cpu
# ------------------------------------------------------------------------------
preps::cpu::reload_cpufreq_driver_module() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  local module="${1}"
  local systemd_unit="${2}"
  local max_active_time="${3}"
  [[ -n "${module}" ]] || 
    { main::log_event -level "ERROR" -message "Missing Argument: [Module]"; return ${rc}; }
  [[ -n "${systemd_unit}" ]] ||
    { main::log_event -level "ERROR" -message "Missing Argument: [systemd Unit]"; return ${rc}; }
  [[ -n "${max_active_time}" ]] ||
    { main::log_event -level "ERROR" -message "Missing Argument: [Max. Active Time]"; return ${rc}; }
  (( max_active_time > 0 )) ||
    { main::log_event -level "ERROR" -message "Invalid Max. Active Time: [${max_active_time}]"; return ${rc}; }
  if systemctl is-active "${systemd_unit}" &> /dev/null; then
    local active_time timestamp1 timestamp2
    timestamp1="$(awk '{printf "%.0f", $1}' "/proc/uptime")"
    timestamp2="$(systemctl show "${systemd_unit}" --property=ActiveEnterTimestampMonotonic | awk -F '=' '{printf "%.0f", $2/(1000*1000)}')"
    active_time=$(( timestamp1 - timestamp2 ))
    if (( active_time > max_active_time )); then
      main::log_event -level "DEBUG" -message "Reloading cpufreq Driver ( Actual Runtime: [${active_time}] > Maximum Runtime: [${max_active_time}] )"
      if modprobe --remove "${module}" &> /dev/null && modprobe "${module}" &> /dev/null; then
        main::log_event -level "INFO" -message "Reloaded Kernel Module: [${module}]"
        if systemctl restart "${systemd_unit}" &> /dev/null; then
          main::log_event -level "INFO" -message "Restarted systemd Unit: [${systemd_unit}]"
        else
          main::log_event -level "ERROR" -message "Failed to Restart systemd Unit: [${systemd_unit}] - Return Code: [$?]"
          rc=1
        fi
      else
        main::log_event -level "ERROR" -message "Failed to Reload Kernel Module: [${module}] - Return Code: [$?]"
        rc=1
      fi
    else
      main::log_event -level "DEBUG" -message "Skipping cpufreq Driver Reload ( Actual Runtime: [${active_time}] < Maximum Runtime: [${max_active_time}] )"
    fi
  else
    main::log_event -level "WARN" -message "Skipping cpufreq Driver Reload ( Inactive systemd Unit: [${systemd_unit}] )"
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}
