#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::memory::compact_memory()
## @brief Compact Memory
## @return Return Code
## @retval 0 Compacted Memory
## @retval 1 Failed to Compact Memory
## @ingroup memory
# ------------------------------------------------------------------------------
preps::memory::compact_memory() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  if ${SUDO} /sbin/sysctl vm.compact_memory=1 &>/dev/null; then
    main::log_event -level "INFO" -message "Compacted Memory"
  else
    main::log_event -level "ERROR" -message "Failed to Compact Memory - Return Code: [$?]"
    rc=1
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
  return ${rc}
}
