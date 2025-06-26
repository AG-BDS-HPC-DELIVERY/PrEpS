#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn apis::nvsmi::set_power_limit()
## @brief Set Power Limit
## @param power_limit Power Limit
## @return Return Code
## @retval NVIDIA SMI Command Return Code
## @ingroup nvsmi
# ------------------------------------------------------------------------------
apis::nvsmi::set_power_limit() {
  while (( $# > 0 )); do
    case "${1}" in
      -id)
        local id="${2}"
        shift
        ;;
      -power_limit)
        local power_limit="${2}"
        shift
        ;;
      -scope)
        local scope="${2}"
        shift
        ;;
      *)
        main::log_event -level "FATAL" -message "Invalid Option: [${1}]"
        ;;
    esac
    shift
  done
  [[ -n "${power_limit}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [Power Limit]"
  (( power_limit > 0 )) || main::log_event -level "FATAL" -message "Invalid Power Limit: [${power_limit}]"
  [[ -n "${scope}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [Scope]"
  (( scope == 0 || scope == 1 )) || main::log_event -level "FATAL" -message "Invalid Scope: [${scope}]"
  ${SUDO} "${NVSMI_EXECBIN}" ${id:+--id="${id}"} --power-limit="${power_limit}" --scope="${scope}" &> /dev/null
  return $?
}
