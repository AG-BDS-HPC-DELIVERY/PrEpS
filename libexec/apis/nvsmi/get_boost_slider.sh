#!/usr/bin/env bash

# ------------------------------------------------------------------------------
## @file
## @fn apis::nvsmi::get_boost_slider()
## @brief Get Boost Slider
## @return Return Code
## @retval 0
## @ingroup nvsmi
# ------------------------------------------------------------------------------
apis::nvsmi::get_boost_slider() {
  while (( $# > 0 )); do
    case "${1}" in
      *)
        main::log_event -level "FATAL" -message "Invalid Option: [${1}]"
        ;;
    esac
    shift
  done
  local boost_slider boost_sliders
  while read -r boost_slider; do
    boost_sliders="${boost_sliders}${boost_sliders:+"${PREPS_MULTIPLE_VALUE_SEPARATOR}"}${boost_slider// /}"
  done < <("${NVSMI_EXECBIN}" boost-slider --list | awk 'match($0, /[0-9]+\s+vboost\s+[0-9]+\s+([0-9]+)/, a) {print a[1]}')
  printf "%s" "${boost_sliders}"
  return 0
}
