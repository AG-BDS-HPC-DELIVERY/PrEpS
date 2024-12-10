#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::reset_gpu()
## @brief Reset GPU
## @return Return Code
## @retval 0 GPU Has Been Successfully Reset
## @retval 1 GPU Could Not Be Reset
## @ingroup nvidia
# ------------------------------------------------------------------------------
preps::nvidia::reset_gpu() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
  if "${NVSMI_EXECBIN}" --gpu-reset &>/dev/null; then
		main::log_event -level "INFO" -message "Reset GPU"
  else
		main::log_event -level "ERROR" -message "Failed to Reset GPU - Return Code: [$?]"
		rc=1
  fi
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
