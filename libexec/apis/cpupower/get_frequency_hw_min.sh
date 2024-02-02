#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::cpupower::get_frequency_hw_min()
## @brief Get Hardware Min. CPU Frequency
## @return Hardware Min. CPU Frequency
## @ingroup cpupower
#-------------------------------------------------------------------------------
apis::cpupower::get_frequency_hw_min() {
	printf "%s" "$(cat "${CPUFREQ_PATH}"/cpuinfo_min_freq)"
}
