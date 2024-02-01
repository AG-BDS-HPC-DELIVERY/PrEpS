#!/usr/bin/env bash

apis::cpupower::get_frequency_min() {
	printf "%s" "$(cat "${CPUFREQ_PATH}"/scaling_min_freq)"
}
