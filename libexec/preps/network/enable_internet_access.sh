#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn preps::network::enable_internet_access()
## @brief Control Internet-enabling routes
## @return Return Code
## @retval 0 Succeeded
## @retval 1 Failed to reserve internet licenses
## @ingroup memory
# ------------------------------------------------------------------------------
preps::network::enable_internet_access() {
  main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
  local -i rc=0
  local enable_internet="${1}"
  [[ -n "${enable_internet}" ]] ||
    { main::log_event -level "ERROR" -message "Missing Argument: [Internet Access]"; return ${rc}; }
  
  if [ ${enable_internet} -eq 1 ];
  then
    if ip route add default via 10.128.254.254 dev ib0 proto static &> /dev/null; then
      main::log_event -level "INFO" -message "IPv4 routes for internet access added"
    else
      main::log_event -level "ERROR" -message "Could not add IPv4 routes for internet access!"
    fi
  fi

  main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]" -rc "${?}"
  return ${rc}
}
