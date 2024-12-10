#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn apis::cpupower::get_frequency_min()
## @brief Get Min. CPU Frequency
## @return Return Code
## @retval 0
## @ingroup cpupower
# ------------------------------------------------------------------------------
apis::cpupower::get_frequency_min() {
	printf "%s" "$(cat "${CPUFREQ_PATH}"/scaling_min_freq)"
	return 0
}
