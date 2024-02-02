#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::cpupower::get_frequency_max()
## @brief Get Max. CPU Frequency
## @return Max. CPU Frequency
## @ingroup cpupower
#-------------------------------------------------------------------------------
apis::cpupower::get_frequency_max() {
	printf "%s" "$(cat "${CPUFREQ_PATH}"/scaling_max_freq)"
}
