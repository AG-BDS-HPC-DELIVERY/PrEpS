#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::cpupower::get_frequency_hw_max()
## @brief Get Hardware Max. CPU Frequency
## @return Hardware Max. CPU Frequency
## @ingroup cpupower
#-------------------------------------------------------------------------------
apis::cpupower::get_frequency_hw_max() {
	printf "%s" "$(cat "${CPUFREQ_PATH}"/cpuinfo_max_freq)"
}
