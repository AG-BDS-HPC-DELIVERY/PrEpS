#!/usr/bin/env bash

#-------------------------------------------------------------------------------
## @file
## @fn preps::nvidia::reload_driver()
## @brief Reload NVIDIA Driver
## @return Return Code
## @retval 0 NVIDIA Driver Has Been Successfully Reloaded
## @retval 1 NVIDIA Driver Could Not Be Reloaded
## @ingroup nvidia
#-------------------------------------------------------------------------------
preps::nvidia::reload_driver() {
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Entering Module: [${FUNCNAME[0]}]"
	# Kernel Modules
	local modules_load=( nv_rsync_mem nvidia_drm nvidia_modeset nvidia_uvm nv_peer_mem nvidia )
	local modules_unload=( nvidia nv_peer_mem nvidia_uvm nvidia_modeset nvidia_drm nv_rsync_mem )
	# Services
	local service_gpusupport="nv_rsync_mem.service"
	local services_start=( nvidia-persistenced.service dcgm.service lsfd.service )
	local services_stop=( lsfd.service dcgm.service nvidia-persistenced.service )
	# Stop NVIDIA Driver-Based Services
	local service
	for service in "${services_stop[@]}"; do
		if [[ $(systemctl is-active ${service}) ]]; then
			if systemctl stop ${service}; then
				main::log_event -level "${LOGGER_LEVEL_DEBUG}" -message "Stopped Service: [${service}]"
			fi
			sleep 5
		fi
	done
	# Stop Potentially Remaining Processes
	if (lsof /dev/nvidia*) && (kill -9 "$(lsof -t /dev/nvidia*)"); then
		main::log_event -level "${LOGGER_LEVEL_DEBUG}" -message "Stopped Remaining Processes Attached to NVIDIA Devices"
	fi
	# NVIDIA Modules Unload
	local module
	for module in "${modules_unload[@]}"; do
		rmmod --verbose "${module}"
		if (( $? == 0 )); then
			main::log_event -level "${LOGGER_LEVEL_DEBUG}" -message "Unloaded Module: [${module}]"
		fi
		sleep 2
	done
	lsmod | grep nvidia
	if (( $? != 0 )); then
		main::log_event -level "${LOGGER_LEVEL_ERROR}" -message "Failed to Unload All NVIDIA Modules"
		main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}]"
		return 1
	fi
	# IBM Spectrum MPI GPU Support
	systemctl start "${service_gpusupport}"
	if (( $? == 0 )); then
		main::log_event -level "${LOGGER_LEVEL_DEBUG}" -message "Reloaded IBM Spectrum MPI GPU Support Module"
	fi
	# NVIDIA Driver Modules
	nvidia-smi >/dev/null 2>&1
	if (( $? == 0 )); then
		main::log_event -level "${LOGGER_LEVEL_INFO}" -message "Reloaded NVIDIA Driver"
	fi
	# NVIDIA Driver-Based Services Startup
	for service in "${services_start[@]}"; do
		systemctl restart "${service}"
		if (( $? == 0 )); then
			main::log_event -level "${LOGGER_LEVEL_DEBUG}" -message "Restarted Service: [${service}]"
		fi
	done
	main::log_event -level "${LOGGER_LEVEL_TRACE}" -message "Exiting Module: [${FUNCNAME[0]}]"
	return 0
}
