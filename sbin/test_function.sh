#!/usr/bin/env bash

function="${1}"
shift
args="${@}"

[[ -n "${function}" ]] || { printf "Missing Argument: [%s]\n" "Function"; exit 1; }

PREPS_PREFIX="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..")"
PREPS_LIBEXECDIR="${PREPS_PREFIX}/libexec"
LOG_LEVEL="TRACE"

# ==============================================================================
# Function: main::log_event
# ==============================================================================
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

# Modules
while IFS= read -d '' -r -u 9 modulefile; do
  module="$(awk 'match($0, /^([_a-z]+::[_a-z]+::[_a-z]+)\(\)/, a) {print a[1]}' "${modulefile}")"
  # shellcheck source=/dev/null
  source "${modulefile}" &>/dev/null || main::log_event -level "WARN" -message "Failed to Load Modulefile: [${modulefile}]" -singleton
  if [[ -n "${module}" ]] && [[ "$(type -t "${module}" 2>/dev/null)" == "function" ]]; then
    # shellcheck disable=SC2163
    export -f "${module}" || main::log_event -level "WARN" -message "Failed to Export Module: [${module}]" -singleton
  fi
done 9< <(find "${PREPS_LIBEXECDIR}"/ -name "*.sh" -print0)

# modulefile="$(grep -rl "${function}" "${PREPS_LIBEXECDIR}")"
# [[ -f "${modulefile}" ]] || { printf "Failed to Locate Modulefile for Function: [%s]\n" "${function}"; exit 1; }
# source "${modulefile}" &>/dev/null || { printf "Failed to Load Modulefile: [%s]\n" "${modulefile}"; exit 1; }

printf "Testing Function: [%s] from Modulefile: [%s] with Arguments: [%s]\n" "${function}" "${modulefile}" "${args}"
printf "Command: [%s]\n" "${function} ${args}"
${function} ${args}
printf "Return Code: [%s]\n" "${?}"

exit 0
