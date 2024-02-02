#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::cpupower::get_frequency_nominal()
## @brief Get Nominal CPU Frequency
## @return Return Code
## @retval 0
## @ingroup cpupower
#-------------------------------------------------------------------------------
apis::cpupower::get_frequency_nominal() {
	printf "%s" "$(cat "${CPUFREQ_PATH}"/cpuinfo_nominal_freq)"
	return 0
}
