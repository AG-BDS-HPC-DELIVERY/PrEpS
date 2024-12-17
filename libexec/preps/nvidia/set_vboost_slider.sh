#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::set_vboost_slider()
## @brief Set Video Boost Slider
## @param vboost Video Boost Slider: {0 | 1 | 2 | 3 | 4}
## @return Return Code
## @retval 0 Successfully Set vboost
## @retval 1 Failed to Set vboost
## @ingroup nvidia
# ------------------------------------------------------------------------------
preps::nvidia::set_vboost_slider() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  local vboost="${1}"
  [[ -n "${vboost}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [Video Boost Slider]"
  (( vboost >= 0 && vboost <= 4 )) || main::log_event -level "FATAL" -message "Invalid Video Boost Slider Value: [${vboost}]"
  if apis::nvsmi::set_boost_slider -vboost "${vboost}"; then
    main::log_event -level "INFO" -message "Set Video Boost Slider: [$(apis::nvsmi::get_boost_slider)]"
  else
    main::log_event -level "ERROR" -message "Failed to Set Video Boost Slider"
    rc=1
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
  return ${rc}
}
