#!/usr/bin/env bash +x

PREPS_PREFIX="$(realpath "$(dirname "${BASH_SOURCE[0]}")"/..)"
PREPS_CONFIGDIR="${PREPS_PREFIX}/etc"
PREPS_LIBEXECDIR="${PREPS_PREFIX}/libexec"

# Host Configuration Libraries
while read -r -u 9 library; do
	if source "${library}" &>/dev/null; then
		printf "[PASSED] "
	else
		printf "[FAILED] "
	fi
	printf "Library: [%s]\n" "${library}"
done 9< <(find ${PREPS_LIBEXECDIR} -name "*.sh")

# LSF Queue Configurations
while read -r -u 9 configfile; do
	if source "${configfile}" &>/dev/null; then
		printf "[PASSED] "
	else
		printf "[FAILED] "
	fi
	printf "Configuration File: [%s]\n" "${configfile}"
done 9< <(find "${PREPS_CONFIGDIR}" -name "*.sh")

exit 0
