#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::cpupower::get_frequency()
## @brief Get CPU Frequency
## @return CPU Frequency
## @ingroup cpupower
#-------------------------------------------------------------------------------
apis::cpupower::get_frequency() {
	"${CPUPOWER_EXECBIN}" frequency-info --freq | awk 'match($0, /current CPU frequency:\s([0-9.]*)\s.*$/, a) {print a[1]}'
}
