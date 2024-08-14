#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::slurm::archive_job()
## @brief Archive Job Execution Environment
## @return Return Code
## @retval 0 Archived Job Execution Environment
## @ingroup slurm
#-------------------------------------------------------------------------------
preps::slurm::archive_job() {
	main::log_event -level "TRACE" -message "Entering Module: [${FUNCNAME[0]}]"
	local rundir && rundir="${PREPS_RUNDIR}/slurm/history/$(date +"%Y")/$(date +"%m")/$(date +"%d")/${SLURM_JOB_ID}"
  mkdir --parent "${rundir}"
	local outfile
  # Job
  if [[ "${SLURMD_NODENAME}" == "${HEADNODE}" ]]; then
    subdir="${rundir}/job"
    mkdir --parent "${subdir}"
    outfile="${subdir}/${SLURM_JOB_ID}.yaml"
  	cat &>"${outfile}" <<- eof
---
scontrol show job: |
$(scontrol show job "${SLURM_JOB_ID}")
eof
    local command
    command="$(awk 'match($0, /Command=(\S+)/, a) {print a[1]}' "${outfile}")"
    [[ -f "${command}" ]] && cp --preserve "${command}" "${subdir}"/
    local stderr
    stderr="$(awk 'match($0, /StdErr=(\S+)/, a) {print a[1]}' "${outfile}")"
    local stdout
    stdout="$(awk 'match($0, /StdOut=(\S+)/, a) {print a[1]}' "${outfile}")"
    [[ -f "${stdout}" ]] && cp --preserve "${stdout}" "${subdir}"/
    [[ "${stderr}" != "${stdout}" && -f "${stderr}" ]] && cp --preserve "${stderr}" "${subdir}"/
  fi
  # Nodes
  subdir="${rundir}/nodes"
  mkdir --parent "${subdir}"
	outfile="${subdir}/${SLURMD_NODENAME}.yaml"
	cat &>"${outfile}" <<- eof
---
hostname: $(hostname)

uptime: |
$(uptime)

uname -a: |
$(uname -a)

/proc/cmdline: |
$(cat /proc/cmdline)

lscpu: |
$(lscpu)

numactl --hardware: |
$(numactl --hardware)

cpupower frequency-info: |
$(cpupower frequency-info)

free: |
$(free -g)

ps auxwf: |
$(ps auxwf)

ibstatus: |
$(/usr/sbin/ibstatus 2>&1)

ibv_devinfo -v: |
$(/usr/bin/ibv_devinfo -v)

env: |
$(env | awk '/^[_0-9A-Za-z]+=/' | sort)

dmesg --ctime: |
$(dmesg --ctime | tail -n 250)

rpm --query: |
$(rpm --query cuda-drivers datacenter-gpu-manager gdrcopy lustre-client mlnx-ofa_kernel nvidia-driver openmpi-bull slurm)
eof
	if "nvidia-smi" &>/dev/null; then
		cat &>>"${outfile}" <<- eof

nvidia-smi: |
$(nvidia-smi)

nvidia-smi --query: |
$(nvidia-smi --query)
eof
	fi
	main::log_event -level "DEBUG" -message "Archived Job Execution Environment into Directory: [${rundir}]"
	main::log_event -level "TRACE" -message "Exiting Module: [${FUNCNAME[0]}]"
	return 0
}
