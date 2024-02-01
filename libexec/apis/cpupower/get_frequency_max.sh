#!/usr/bin/env bash

apis::cpupower::get_frequency_max() {
	printf "%s" "$(cat "${CPUFREQ_PATH}"/scaling_max_freq)"
}
