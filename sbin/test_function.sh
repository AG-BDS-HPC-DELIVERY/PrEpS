#!/usr/bin/env bash

function="${1}"
shift
args="${@}"

[[ -n "${function}" ]] || { printf "Missing Argument: [%s]\n" "Function"; exit 1; }

PREPS_PREFIX="$(realpath "$(dirname "${BASH_SOURCE[0]}")"/..)"
PREPS_LIBEXECDIR="${PREPS_PREFIX}/libexec"
LOG_LEVEL="TRACE"

#===============================================================================
# Function: main::log_event
#===============================================================================
declare -A LOG_LEVELS=([TRACE]=0 [DEBUG]=1 [INFO]=2 [WARN]=3 [ERROR]=4 [FATAL]=5)
main::log_event() {
	declare -A log_levels=([TRACE]=0 [DEBUG]=1 [INFO]=2 [WARN]=3 [ERROR]=4 [FATAL]=5)
	while (( $# > 0 )); do
		case "${1}" in
			-level)
				local level="${2}"
				shift
				;;
			-message)
				local message="${2}"
				shift
				;;
		esac
		shift
	done
	(( ${log_levels[${level}]} >= ${log_levels[${LOG_LEVEL}]} )) || return 0
	[[ "${level}" == "FATAL" ]] && message="${message:-Undefined Exception} @ ${FUNCNAME[1]}:${BASH_LINENO[0]}"
	printf "%26s | %8s | %-15s | %-15s | %-20s | %-5s | %s\n" \
		"$(date "+%Y-%m-%d %H:%M:%S %:z")" \
		"${SLURM_JOB_ID}" \
		"${SLURM_JOB_USER}" \
		"$(hostname --short)" \
		"${SLURM_SCRIPT_CONTEXT}" \
		"${level}" \
		"${message}"
	return 0
}

modulefile="$(grep -rl "${function}" "${PREPS_LIBEXECDIR}")"
[[ -f "${modulefile}" ]] || { printf "Failed to Locate Modulefile for Function: [%s]\n" "${function}"; exit 1; }
source "${modulefile}" &>/dev/null || { printf "Failed to Load Modulefile: [%s]\n" "${modulefile}"; exit 1; }

printf "Testing Function: [%s] from Modulefile: [%s] with Arguments= [%s]\n" "${function}" "${modulefile}" "${args}"
${function} ${args}
printf "Return Code: [%s]\n" "${?}"

exit 0
