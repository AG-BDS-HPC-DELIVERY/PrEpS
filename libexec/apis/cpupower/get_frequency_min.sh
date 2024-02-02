#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::cpupower::get_frequency_min()
## @brief Get Min. CPU Frequency
## @return Min. CPU Frequency
## @ingroup cpupower
#-------------------------------------------------------------------------------
apis::cpupower::get_frequency_min() {
	printf "%s" "$(cat "${CPUFREQ_PATH}"/scaling_min_freq)"
}
