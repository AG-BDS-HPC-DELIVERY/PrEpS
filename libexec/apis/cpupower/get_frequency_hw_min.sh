#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn apis::cpupower::get_frequency_hw_min()
## @brief Get Hardware Min. CPU Frequency
## @return Return Code
## @retval 0
## @ingroup cpupower
# ------------------------------------------------------------------------------
apis::cpupower::get_frequency_hw_min() {
	printf "%s" "$(cat "${CPUFREQ_PATH}"/cpuinfo_min_freq)"
	return 0
}
