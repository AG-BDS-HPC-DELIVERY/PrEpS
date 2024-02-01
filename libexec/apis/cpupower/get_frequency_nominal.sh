#!/usr/bin/env bash

apis::cpupower::get_frequency_nominal() {
	printf "%s" "$(cat "${CPUFREQ_PATH}"/cpuinfo_nominal_freq)"
}
