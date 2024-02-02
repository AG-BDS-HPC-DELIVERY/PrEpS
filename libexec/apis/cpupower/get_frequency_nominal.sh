#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::cpupower::get_frequency_nominal()
## @brief Get Nominal CPU Frequency
## @return Nominal CPU Frequency
## @ingroup cpupower
#-------------------------------------------------------------------------------
apis::cpupower::get_frequency_nominal() {
	printf "%s" "$(cat "${CPUFREQ_PATH}"/cpuinfo_nominal_freq)"
}
