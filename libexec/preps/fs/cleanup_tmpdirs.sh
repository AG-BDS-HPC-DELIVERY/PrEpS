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
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local -i rc=0
	local tmpdirs && IFS="," read -a tmpdirs -r <<<"${1}"
	[[ -n "${tmpdirs[*]}" ]] || main::log_event -level "FATAL" -message "Missing Argument: [Temporary Directories]"
	local tmpdir
	for tmpdir in "${tmpdirs[@]}"; do
		if (( SLURM_JOB_UID > 1000 )); then
			local tmpuserdir
			while read -r -u 9 tmpuserdir; do
				if rm --force --recursive "${tmpuserdir}" &>/dev/null; then
					main::log_event -level "DEBUG" -message "Removed User-Owned Temporary Directory: [${tmpuserdir}]"
				else
					main::log_event -level "ERROR" -message "Failed to Remove User-Owned Temporary Directory: [${tmpuserdir}]"
					rc=1
				fi
			done 9< <(find "${tmpdir}" -maxdepth 1 -mindepth 1 -type d -user "${SLURM_JOB_USER}")
		fi
	done
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
