#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn apis::cpupower::get_frequency_hw_max()
## @brief Get Hardware Max. CPU Frequency
## @return Return Code
## @retval 0
## @ingroup cpupower
# ------------------------------------------------------------------------------
apis::cpupower::get_frequency_hw_max() {
	printf "%s" "$(cat "${CPUFREQ_PATH}"/cpuinfo_max_freq)"
	return 0
}
