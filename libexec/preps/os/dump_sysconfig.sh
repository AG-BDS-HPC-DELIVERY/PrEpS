#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::os::dump_sysconfig()
## @brief Dump System Configuration
## @return Return Code
## @retval 0 Dumped System Configuration
## @ingroup os
#-------------------------------------------------------------------------------
preps::os::dump_sysconfig() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local rundir && rundir="${PREPS_RUNDIR}/sysconfig/$(date +"%Y")/$(date +"%m")/${SLURM_JOB_ID}"
  mkdir --parent "${rundir}"
	#local dumpfile && dumpfile="${SLURM_JOB_WORK_DIR}/system-config.${SLURM_JOB_ID}.$(hostname).yml"
	local outfile && outfile="${rundir}/$(hostname).yml"
	# Header
	cat >"${outfile}" <<- eof
---
hostname: |
$(hostname)

uname -a: |
$(uname -a)

lscpu: |
$(lscpu)

numactl --hardware: |
$(numactl --hardware)

cpupower frequency-info: |
$(cpupower frequency-info)

free: |
$(free -g)

ps aux: |
$(ps aux)

scontrol show job: |
$(scontrol show job "${SLURM_JOB_ID}")

ibstatus: |
$(ibstatus)

ibv_devinfo -v: |
$(ibv_devinfo -v)
eof
	if "nvidia-smi" &>/dev/null; then
		cat >>"${outfile}" <<- eof

nvidia-smi: |
$(nvidia-smi)

nvidia-smi --query: |
$(nvidia-smi --query)
eof
	fi
  command="$(squeue --format="%o" --job="${SLURM_JOB_ID}" --noheader)"
  [[ -f "${command}" ]] && cp --preserve "${command}" "${rundir}"/
	main::log_event -level "DEBUG" -message "Dumped System Configuration into YAML File: [${outfile}]"
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]"
	return 0
}
