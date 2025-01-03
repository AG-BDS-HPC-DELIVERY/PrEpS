#!/bin/bash

# Environment
prefix="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..")"
execbindir="${prefix}/bin"
execbin="${execbindir}/preps"
[[ -x "${execbin}" ]] || { printf "Invalid Executable: [%s]\n" "${execbin}"; exit 1; }
printf "PrEpS Executable: [%s]\n" "${execbin}"

# Execution Arguments
while (( $# > 0 )); do
  case "${1}" in
    -help|-h)
      cat <<- eof >&1

Tester for Prolog/Epilog for Slurm (PrEpS)

Usage: $(basename "${BASH_SOURCE[0]}") [-slurm_job_comment COMMENT] [-slurm_script_context CONTEXT]

Options:
  -slurm_script_context CONTEXT    Context: {epilog_slurmd | prolog_slurmd*}
  -slurm_job_comment COMMENT       Semi-Colon Separated List of 'Key=Value' Pairs
                                     PREPS_ALT_PREFIX=${prefix}
                                     PREPS_HEADNODE=${HOSTNAME}
                                     PREPS_LOG_LEVEL=TRACE

eof
      exit 0
      ;;
    -slurm_job_comment)
      export SLURM_JOB_COMMENT="${2}"
      shift
      ;;
    -slurm_script_context)
      export SLURM_SCRIPT_CONTEXT="${2}"
      shift
      ;;
    *)
      break
      ;;
  esac
  shift
done
export SLURM_SCRIPT_CONTEXT="${SLURM_SCRIPT_CONTEXT:-prolog_slurmd}"
export SLURM_JOB_ID="12345678"
export SLURM_JOB_USER="${USER}"
export SLURMD_NODENAME="${HOSTNAME}"

printf "Testing PrEpS\n"
printf -- "- Command: [%s]\n" "${execbin}"
printf -- "- SLURM_JOB_COMMENT: [%s]\n" "${SLURM_JOB_COMMENT}"
printf -- "- SLURM_SCRIPT_CONTEXT: [%s]\n" "${SLURM_SCRIPT_CONTEXT}"

${execbin} ${execargs}
printf "Return Code: [%s]\n" "${?}"

exit 0
