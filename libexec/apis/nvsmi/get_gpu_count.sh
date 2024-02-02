#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn apis::nvsmi::get_gpu_count()
## @brief Get Compute Mode
## @return Return Code
## @retval 0
## @ingroup nvsmi
#-------------------------------------------------------------------------------
apis::nvsmi::get_gpu_count() {
	local gpu_count=0
	gpu_count="$(${NVSMI_EXECBIN} --format=csv,noheader,nounits --query-gpu=count 2>/dev/null | head --lines=1)"
	if [[ "${gpu_count}" == "No devices were found" ]]; then
		gpu_count=0
	fi
	echo "${gpu_count}"
	return 0
}
