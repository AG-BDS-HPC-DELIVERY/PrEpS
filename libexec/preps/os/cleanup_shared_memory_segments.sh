#!/usr/bin/env bash

preps::os::cleanup_shared_memory_segments() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local shm
	local -i count_1=0
	local -i count_2=0
	while IFS= read -d '' -r -u 9 shm; do
		if rm --force "${shm}" &>/dev/null; then
			main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Removed User-Owned Shared Memory Segment: [${shm}]"
			(( count_1 += 1 ))
		else
			main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Failed to Remove User-Owned Shared Memory Segment: [${shm}]"
			(( count_2 += 1 ))
		fi
	done 9< <(find /dev/shm/ -type f -print0 -user "${LSB_JOB_EXECUSER}")
	if (( count_1 > 0 )); then
		main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Removed User-Owned Shared Memory Segments - Total Count: [${count_1}]"
	fi
	if (( count_2 > 0 )); then
		main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed to Remove User-Owned Shared Memory Segments - Total Count: [${count_2}]"
		rc=1
	fi
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
