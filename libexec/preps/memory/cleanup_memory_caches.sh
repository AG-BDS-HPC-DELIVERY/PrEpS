#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::memory::cleanup_memory_caches()
## @brief Cleanup Memory Caches
## @param caches = {1: pagecache | 2: dentries + inodes | 3: pagecache + dentries + inodes}
## @return Return Code
## @retval 0 Dropped Memory Caches
## @retval 1 Failed to Drop Memory Caches
## @ingroup memory
# ------------------------------------------------------------------------------
preps::memory::cleanup_memory_caches() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  local caches="${1}"
  [[ -n "${caches}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [Caches]"
  (( caches == 1 || caches == 2 || caches == 3 )) || \
    main::log_event -level "FATAL" -message "Invalid Caches Value: [${caches}]"
  /usr/bin/sync
  if ${SUDO} /sbin/sysctl vm.drop_caches=${caches} &>/dev/null; then
    main::log_event -level "INFO" -message "Dropped Memory Caches"
  else
    main::log_event -level "ERROR" -message "Failed to Drop Memory Caches - Return Code: [$?]"
    rc=1
  fi
  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
  return ${rc}
}
