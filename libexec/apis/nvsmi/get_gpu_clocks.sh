#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn apis::nvsmi::get_gpu_clocks()
## @brief Get GPU Clocks
## @param id GPU ID
## @return Return Code
## @retval 0
## @ingroup nvsmi
# ------------------------------------------------------------------------------
apis::nvsmi::get_gpu_clocks() {
  while (( $# > 0 )); do
    case "${1}" in
      -id)
        local id="${2}"
        shift
        ;;
      *)
        main::log_event -level "FATAL" -message "Invalid Option: [${1}]"
        ;;
    esac
    shift
  done
  local clocks1 clocks2
  while read -r -u 9 clocks1; do
    clocks2="${clocks2}${clocks2:+"${PREPS_MULTIPLE_VALUE_SEPARATOR}"}${clocks1// /}"
  done 9< <("${NVSMI_EXECBIN}" --format="csv,noheader,nounits" ${id:+--id="${id}"} --query-gpu="clocks.current.graphics")
  printf "%s" "${clocks2}"
  return 0
}
