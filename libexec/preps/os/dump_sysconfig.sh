#!/usr/bin/env bash

preps::os::dump_sysconfig() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local dumpfile && dumpfile="${SLURM_JOB_WORK_DIR}/system-config.${SLURM_JOB_ID}.$(hostname).yml"
	# Header
	cat >"${dumpfile}" <<- eof
---
hostname: $(hostname)
eof
	# SMT
	cat >>"${dumpfile}" <<- eof
smt: $(apis::ppc64::smt_get)
eof
	# CPU Frequency
	cat >>"${dumpfile}" <<- eof
governor: $(apis::cpupower::governor_get)
frequencyMin: $(apis::cpupower::frequency_min_get)
frequencyMinHw: $(apis::cpupower::frequency_hw_min_get)
frequency: $(apis::cpupower::get_frequency)
frequencyMax: $(apis::cpupower::frequency_max_get)
frequencyMaxHw: $(apis::cpupower::frequency_hw_max_get)
gpus:
eof
	# GPU Devices
	for id in $(apis::nvsmi::gpu_indexes_get); do
		cat >>"${dumpfile}" <<- eof
- gpuId: ${id}
  applicationsClocks: $(apis::nvsmi::applications_clocks_get _id "${id}")
  applicationsClocksMax: $(apis::nvsmi::applications-clocks_max_get _id "${id}")
  computeMode: $(apis::nvsmi::compute_mode_get _id "${id}")
  persistenceMode: $(apis::nvsmi::persistence_mode_get _id "${id}")
  powerLimit: $(apis::nvsmi::power_limit_get _id "${id}")
  powerLimitMax: $(nvidia-smi --format=csv,noheader,nounits --id="${id}" --query-gpu="power.max_limit")
eof
	done
	# System Memory
	cat >>"${dumpfile}" <<- eof
---
free: |
$(free -g)
eof
	# cpupower
	cat >>"${dumpfile}" <<- eof
---
frequency-info: |
$(cpupower frequency-info)
eof
	# NVIDIA SMI
	cat >>"${dumpfile}" <<- eof
---
nvidia-smi: |
$(nvidia-smi)
eof
	# NVIDIA SMI Query
	cat >>"${dumpfile}" <<- eof
---
nvidia-smi --query: |
$(nvidia-smi --query)
eof
	# Spectrum LSF bhosts
	cat >>"${dumpfile}" <<- eof
---
bhosts -gpu -l $(hostname) |
$(bhosts -gpu -l "$(hostname)")
eof
	# Spectrum LSF lshosts
	cat >>"${dumpfile}" <<- eof
---
lshosts -gpu $(hostname) |
$(lshosts -gpu "$(hostname)")
eof
	# ps
	cat >>"${dumpfile}" <<- eof
---
ps aux: |
$(ps aux)
eof
	# ENV
	cat >>"${dumpfile}" <<- eof
---
env: |
$(env | sort)
eof
	main::log_event -level "${LOGGER_LEVEL_DEBUG}" -message "Dumped Host Configuration into YAML File: [${dumpfile}]"
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}]"
	return 0
}
