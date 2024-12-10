#!/usr/bin/env bash

PREPS_PREFIX="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..")"
PREPS_LIBEXECDIR="${PREPS_PREFIX}/libexec"

total=0
invalid=0
valid=0
while IFS= read -r modulefile; do
  module="$(awk 'match($0, /(.*::.*::.*)\(\)/, a) {print a[1]}' ${modulefile})"
  #module="$(basename ${modulefile} .sh)"
  #module="${module//./::}"
  if [[ "$(type -t "${module}" 2>/dev/null)" != "function" ]]; then
    (( total += 1 ))
    # shellcheck source=/dev/null.
    if source "${modulefile}" &>/dev/null; then
      echo "[  OK  ] Loading Modulefile Succeeded: [${modulefile}]"
      (( valid += 1 ))
    else
      echo "[FAILED] Loading Modulefile Failed: [${modulefile}]"
      (( invalid += 1 ))
    fi
  fi
done < <(find "${PREPS_LIBEXECDIR}/" -name "*.sh")
printf "Summary:\nTotal Files: [%d] / Valid: [%d] / Invalid: [%d]\n" "${total}" "${valid}" "${invalid}"

exit 0
