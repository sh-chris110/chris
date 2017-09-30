set_global_assignment -entity "hps_design" -library "lib_hps_design" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "hps_design" -library "lib_hps_design" -name IP_TOOL_VERSION "15.0"
set_global_assignment -entity "hps_design" -library "lib_hps_design" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_hps_design" -name SPD_FILE [file join $::quartus(sip_path) "../hps_design.spd"]
set_global_assignment -library "lib_hps_design" -name MISC_FILE [file join $::quartus(sip_path) "../../hps_design.qsys"]

set_global_assignment -library "lib_hps_design" -name MISC_FILE [file join $::quartus(sip_path) "hps_design.v"]
set_global_assignment -library "lib_hps_design" -name MISC_FILE [file join $::quartus(sip_path) "submodules/hps_design_pll_0.vo"]
set_global_assignment -library "lib_hps_design" -name MISC_FILE [file join $::quartus(sip_path) "submodules/hps_design_pio_0.v"]
set_global_assignment -library "lib_hps_design" -name MISC_FILE [file join $::quartus(sip_path) "submodules/hps_design_hps_0.v"]
