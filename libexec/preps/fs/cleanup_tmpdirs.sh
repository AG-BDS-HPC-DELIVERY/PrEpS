#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::fs::cleanup_tmpdirs()
## @brief Cleanup Temporary Directories
## @param mountpoints Comma-Separated List of Temporary Directories
## @return Return Code
## @retval 0 All Temporary Directories Have Been Successfully Cleaned Up
## @retval 1 Not All Temporary Directories Could Be Cleaned Up
## @ingroup fs
#-------------------------------------------------------------------------------
preps::fs::cleanup_tmpdirs() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local tmpdirs && IFS="," read -a tmpdirs -r <<<"${1}"
	if [[ -z "${tmpdirs[*]}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [Temporary Directories]"
	fi
	local tmpdir
	for tmpdir in "${tmpdirs[@]}"; do
		if (( SLURM_JOB_UID > 1000 )); then
			# Temporary Directories
			local subdir
			while read -r -u 9 subdir; do
				if rm --force --recursive "${tmpdir}" &>/dev/null; then
					main::log_event -level "${LOGGER_LEVEL_DEBUG}" -message "Removed User-Owned Temporary Directory: [${tmpdir}]"
				else
					main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed to Remove User-Owned Temporary Directory: [${tmpdir}]"
					rc=1
				fi
			done 9< <(find "${tmpdir}" -maxdepth 1 -mindepth 1 -type d -user "${SLURM_JOB_USER}")
			# Temporary Files
			# local tmpfile
			# for tmpfile in $(find /tmp/ -maxdepth 1 ! -name '.*' -type f -user ${LSB_JOB_EXECUSER}); do
			# 	rm --force "${tmpfile}"
			# 	if (( $? == 0 )); then
			# 		main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Removed User-Owned Temporary File: [${tmpfile}]"
			# 	fi
			# done
		fi
	done
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
