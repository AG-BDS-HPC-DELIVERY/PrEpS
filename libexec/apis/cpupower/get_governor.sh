#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::cpupower::get_governor()
## @brief Get CPU Governor
## @return CPU Governor
## @ingroup cpupower
#-------------------------------------------------------------------------------
apis::cpupower::get_governor() {
	printf "%s" "$(${CPUPOWER_EXECBIN} frequency-info --proc | awk 'match($0, /^CPU[0-9]*.*-\s*(.*)$/, a) {print a[1]}' | uniq)"
}
