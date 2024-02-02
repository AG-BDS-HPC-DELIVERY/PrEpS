#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::nvsmi::get_gpu_indexes()
## @brief Get GPU Indexes
## @return Return Code
## @retval 0
## @ingroup nvsmi
#-------------------------------------------------------------------------------
apis::nvsmi::get_gpu_indexes() {
	local gpu_indexes
	if (( $(apis::nvsmi::get_gpu_count) > 0 )); then
		gpu_indexes="$(${NVSMI_EXECBIN} --format=csv,noheader,nounits --query-gpu=index 2>/dev/null)"
	else
		gpu_indexes=""
	fi
	echo "${gpu_indexes}"
	return 0
}
