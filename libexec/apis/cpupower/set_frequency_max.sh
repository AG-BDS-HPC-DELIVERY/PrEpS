#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn apis::cpupower::set_frequency_max()
## @brief Set Max. CPU Frequency
## @param frequency_max Max. CPU Frequency
## @return Return Code
## @retval cpupower Command Return Code
## @ingroup cpupower
# ------------------------------------------------------------------------------
apis::cpupower::set_frequency_max() {
  while (( $# > 0 )); do
    case "${1}" in
      -frequency_max)
        local frequency_max="${2}"
        shift
        ;;
      *)
        main::log_event -level "FATAL" -message "Invalid Option: [${1}]"
        ;;
    esac
    shift
  done
  [[ -n "${frequency_max}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [Frequency Max.]"
  ${SUDO} "${CPUPOWER_EXECBIN}" frequency-set --max "${frequency_max}" &>/dev/null
  return $?
}
