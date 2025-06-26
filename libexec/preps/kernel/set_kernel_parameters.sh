#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::kernel::set_kernel_parameters()
## @brief Set Kernel Parameters
## @return Return Code
## @retval 0 Set Kernel Parameters
## @retval 1 Failed to Set Kernel Parameters
## @ingroup kernel
# ------------------------------------------------------------------------------
preps::kernel::set_kernel_parameters() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  local kernel_parameters="${1}"
  [[ -n "${kernel_parameters}" ]] ||
    { main::log_event -level "ERROR" -message "Missing Argument: [Kernel Parameters]"; return ${rc}; }
  local allowed_parameters
  IFS=" " read -a parameters_allowed -r <<< "${KERNEL_PARAMETERS_ALLOWED[*]}"
  IFS="," read -a parameters -r <<< "${kernel_parameters}"
  for parameter in "${parameters[@]}"; do
    IFS="=" read -r key value <<< "${parameter}"
    if [[ " ${parameters_allowed[@]} " =~ " ${key} " ]]; then
      if ${SUDO} /sbin/sysctl ${key}=${value} &> /dev/null; then
        main::log_event -level "INFO" -message "Set Kernel Parameter: [${key}] to Value: [${value}]"
      else
        main::log_event -level "ERROR" -message "Failed to Set Kernel Parameter: [${key}] - Return Code: [$?]"
      fi
    else
      main::log_event -level "ERROR" -message "Disallowed to Set Kernel Parameter: [${key}] - Return Code: [$?]"
    fi
  done
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}
