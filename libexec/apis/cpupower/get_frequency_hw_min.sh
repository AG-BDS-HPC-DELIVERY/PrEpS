#!/usr/bin/env bash

apis::cpupower::get_frequency_hw_min() {
	printf "%s" "$(cat "${CPUFREQ_PATH}"/cpuinfo_min_freq)"
}
