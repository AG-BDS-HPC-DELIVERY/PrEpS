#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::cpufreq::set_frequency_min_max()
## @brief Set CPU Min./Max. Frequency
## @param frequencies Min./Max. Frequencies: FREQ_MIN:FREQ_MAX
## @return Return Code
## @retval 0 Successfully Set CPU Min./Max. Frequency
## @retval 1 Failed to Set CPU Min./Max. Frequency
## @ingroup cpufreq
# ------------------------------------------------------------------------------
preps::cpufreq::set_frequency_min_max() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  local frequencies && IFS=":" read -a frequencies -r <<<"${1}"
  local frequency_min="${frequencies[0]}"
  local frequency_max="${frequencies[1]}"
  [[ -n "${frequency_max}" ]] ||
    { main::log_event -level "ERROR" -message "Missing Argument: [Frequency Max.]"; return ${rc}; }
  [[ -n "${frequency_min}" ]] ||
    { main::log_event -level "ERROR" -message "Missing Argument: [Frequency Min.]"; return ${rc}; }
  if apis::cpupower::set_frequency_minmax -frequency_max "${frequency_max}" -frequency_min "${frequency_min}"; then
    main::log_event -level "INFO" -message "Set CPU Frequency Limits: [$(apis::cpupower::get_frequency_min)]-[$(apis::cpupower::get_frequency_max)] ( Hardware Limits: [$(apis::cpupower::get_frequency_hw_min)]-[$(apis::cpupower::get_frequency_hw_max)] )"
  else
    main::log_event -level "ERROR" -message "Failed to Set CPU Frequency Min./Max. - Return Code: [$?]"
    rc=1
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}
