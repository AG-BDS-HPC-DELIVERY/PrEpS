#!/usr/bin/env bash

apis::cpupower::get_frequency_hw_max() {
	printf "%s" "$(cat "${CPUFREQ_PATH}"/cpuinfo_max_freq)"
}
