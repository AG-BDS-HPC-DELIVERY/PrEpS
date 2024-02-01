#!/usr/bin/env bash

preps::os::cleanup_ipc() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local shmid
	local -i count_1=0
	local -i count_2=0
	while IFS= read -d '' -r -u 9 shmid; do
		if ipcrm --shmem-id "${shmid}" &>/dev/null; then
			main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Removed User-Owned IPC: [${shmid}]"
			(( count_1 += 1 ))
		else
			main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Failed to Remove User-Owned IPC: [${shmid}]"
			(( count_2 += 1 ))
		fi
	done 9< <(ipcs --creator --shmems | grep "$(id --user "${SLURM_JOB_USER}")" | awk '{print $2}')
	if (( count_1 > 0 )); then
		main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Removed User-Owned IPC - Total Count: [${count_1}]"
	fi
	if (( count_2 > 0 )); then
		main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed to Remove User-Owned IPC - Total Count: [${count_2}]"
		rc=1
	fi
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
