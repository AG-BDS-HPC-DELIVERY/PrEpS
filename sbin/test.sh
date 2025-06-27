#!/bin/bash

# Environment
dir="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
echo dir=$dir
prefix="$(realpath "${dir}/..")"
execbindir="${prefix}/bin"
execbin="${execbindir}/preps"
[[ -x "${execbin}" ]] || { printf "Invalid Executable: [%s]\n" "${execbin}"; exit 1; }
printf "PrEpS Executable: [%s]\n" "${execbin}"

# Execution Arguments
while (( $# > 0 )); do
  case "${1}" in
    --help|-h)
      cat <<- eof >&1

Tester for Prolog/Epilog for Slurm (PrEpS)

Usage: $(basename "${BASH_SOURCE[0]}") [--comment COMMENT] [--context CONTEXT]

Options:
  --comment COMMENT    Semi-Colon Separated List of 'Key=Value' Pairs
                         PREPS_ALT_PREFIX=${prefix}
                         PREPS_NODENAME=${HOSTNAME}
                         PREPS_LOG_LEVEL=TRACE
  --context CONTEXT    Context: {epilog_slurmd | prolog_slurmd*}

eof
      exit 0
      ;;
    --comment)
      export SLURM_JOB_COMMENT="${2}"
      shift
      ;;
    --context)
      export SLURM_SCRIPT_CONTEXT="${2}"
      shift
      ;;
    *)
      printf "Invalid Option: [%s]\n" "${1}"
      exit 1
      ;;
  esac
  shift
done
#export PREPS_EXECBINDIR="${dir}"
export SLURM_SCRIPT_CONTEXT="${SLURM_SCRIPT_CONTEXT:-prolog_slurmd}"
export SLURM_JOB_ID="12345678"
export SLURM_JOB_USER="${USER}"
export SLURMD_NODENAME="$(hostname --short)"

printf "Testing PrEpS\n"
env | grep -Ei "^SLURM" | sort
${execbin}
printf "Return Code: [%s]\n" "${?}"

exit 0
