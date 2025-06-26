#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::check_uncorrectable_errors()
## @brief Check Uncorrectable Errors
## @return Return Code
## @retval 0 No Uncorrectable Error Found
## @retval 1 Uncorrectable Errors Found
## @ingroup nvidia
# ------------------------------------------------------------------------------
preps::nvidia::check_uncorrectable_errors() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  read -r errors < <("${NVSMI_EXECBIN}" --display="ECC" --query \
    | awk '/Volatile/,/DRAM Uncorrectable/' \
    | awk 'BEGIN {sum = 0} match($0, /DRAM Uncorrectable\s+:\s+([0-9]+)$/, a) {sum = sum + a[1]} END {print sum}')
  if (( errors > 0 )); then
    main::log_event -level "WARN" -message "Found Uncorrectable Errors: [${errors}]"
    rc=1
  else
    main::log_event -level "INFO" -message "Found No Uncorrectable Errors"
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}
