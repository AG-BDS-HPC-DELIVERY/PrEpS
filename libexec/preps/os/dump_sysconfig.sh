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
	local dumpfile && dumpfile="${SLURM_JOB_WORK_DIR}/system-config.${SLURM_JOB_ID}.$(hostname).yml"
	# Header
	cat >"${dumpfile}" <<- eof
---
hostname: $(hostname)
eof
	# CPU Frequency
	cat >>"${dumpfile}" <<- eof
governor: $(apis::cpupower::get_governor)
frequencyMin: $(apis::cpupower::get_frequency_min)
frequencyMinHw: $(apis::cpupower::get_frequency_hw_min)
frequency: $(apis::cpupower::get_frequency)
frequencyMax: $(apis::cpupower::get_frequency_max)
frequencyMaxHw: $(apis::cpupower::get_frequency_hw_max)
gpus:
eof
	# GPU Devices
	for id in $(apis::nvsmi::get_gpu_indexes); do
		cat >>"${dumpfile}" <<- eof
- gpuId: ${id}
  applicationsClocks: $(apis::nvsmi::get_applications_clocks -id "${id}")
  applicationsClocksMax: $(apis::nvsmi::get_applications_clocks_max -id "${id}")
  computeMode: $(apis::nvsmi::get_compute_mode -id "${id}")
  persistenceMode: $(apis::nvsmi::get_persistence_mode -id "${id}")
  powerLimit: $(apis::nvsmi::get_power_limit -id "${id}")
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
	main::log_event -level "DEBUG" -message "Dumped Host Configuration into YAML File: [${dumpfile}]"
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]"
	return 0
}
