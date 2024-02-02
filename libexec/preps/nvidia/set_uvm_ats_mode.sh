#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::set_uvm_ats_mode()
## @brief Set UVM ATS Mode
## @param ats_mode ATS Mode
## @return Return Code
## @retval 0 Successfully Set UVM ATS Mode
## @retval 1 Failed to Set UVM ATS Mode
## @ingroup nvidia
#-------------------------------------------------------------------------------
preps::nvidia::set_uvm_ats_mode() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	local module_uvm && module_uvm="$(find /usr/lib/modules -name nvidia-uvm.ko.xz -type f)"
	local module_uvm_parameter_ats_mode="/sys/module/nvidia_uvm/parameters/uvm8_ats_mode"
	local -i rc=0
	local ats_mode="${1}"
	if [[ -z "${ats_mode}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Missing Argument: [ATS Mode]"
	fi
	if (( ats_mode != 0 )) && (( ats_mode != 1 )); then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Invalid ATS Mode: [${ats_mode}]"
	fi
	if [[ ! -f "${module_uvm}" ]]; then
		main::log_event -level "${LOGGER_LEVEL_CRIT}" -message "Invalid UVM Module: [${module_uvm}]"
	fi
	if rmmod nvidia_uvm &>/dev/null; then
		main::log_event -level "${LOGGER_LEVEL_DEBUG}" -message "Unloaded NVIDIA UVM Module"
		if insmod "${module_uvm}" uvm8_ats_mode="${ats_mode}"; then
			main::log_event -level "${LOGGER_LEVEL_DEBUG}" -message "Reloaded NVIDIA UVM Module with ATS Mode: [${ats_mode}]"
			main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Applied NVIDIA UVM Module ATS Mode: [$(cat ${module_uvm_parameter_ats_mode})]"
		else
			main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed to Reload NVIDIA UVM Module"
			rc=1
		fi
	else
		main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed to Unload NVIDIA UVM Module"
		rc=1
	fi
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}] -> Return Code: [${rc}]"
	return ${rc}
}
