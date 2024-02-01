#!/usr/bin/env bash

apis::nvsmi::get_gpu_indexes() {
	local gpu_indexes
	if (( $(apis::nvsmi::gpu_count_get) > 0 )); then
		gpu_indexes="$(${NVSMI_EXECBIN} --format=csv,noheader,nounits --query-gpu=index 2>/dev/null)"
	else
		gpu_indexes=""
	fi
	echo "${gpu_indexes}"
	return 0
}
