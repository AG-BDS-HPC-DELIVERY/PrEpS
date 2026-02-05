#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn apis::nvsmi::lock_gpu_clocks()
## @brief Lock GPU Clocks
## @param clocks GPU Clocks: MIN_GPU_CLOCK,MAX_GPU_CLOCK
## @param id GPU ID
## @param mode Locking Mode: 0=Highest Frequency Accuracies (Default) / 1=Improved Performance per Watt
## @return Return Code
## @retval NVIDIA SMI Command Return Code
## @ingroup nvsmi
# ------------------------------------------------------------------------------
apis::nvsmi::lock_gpu_clocks() {
  local -i mode=0
  while (( $# > 0 )); do
    case "${1}" in
      -clocks)
        local clocks="${2}"
        shift
        ;;
      -id)
        local id="${2}"
        shift
        ;;
      -mode)
        local -i mode=${2}
        (( mode == 0 || mode == 1 )) || main::log_event -level "FATAL" -message "Invalid Locking Mode: [${mode}]"
        shift
        ;;
      *)
        main::log_event -level "FATAL" -message "Invalid Option: [${1}]"
        ;;
    esac
    shift
  done
  [[ -n "${clocks}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [Clocks]"
  ${SUDO} "${NVSMI_EXECBIN}" ${id:+--id="${id}"} --lock-gpu-clocks="${clocks}" --mode=${mode} &> /dev/null
  return $?
}
