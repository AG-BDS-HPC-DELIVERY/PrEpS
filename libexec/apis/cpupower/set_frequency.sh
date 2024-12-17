#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn apis::cpupower::set_frequency()
## @brief Set CPU Frequency
## @param frequency CPU Frequency
## @return Return Code
## @retval cpupower Command Return Code
## @ingroup cpupower
# ------------------------------------------------------------------------------
apis::cpupower::set_frequency() {
  while (( $# > 0 )); do
    case "${1}" in
      -frequency)
        local frequency="${2}"
        shift
        ;;
      *)
        main::log_event -level "FATAL" -message "Invalid Option: [${1}]"
        ;;
    esac
    shift
  done
  [[ -n "${frequency}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [Frequency]"
  ${SUDO} "${CPUPOWER_EXECBIN}" frequency-set --freq "${frequency}" &>/dev/null
  return $?
}
