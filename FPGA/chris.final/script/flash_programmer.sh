#!/bin/sh
#
# This file was automatically generated.
#
# It can be overwritten by nios2-flash-programmer-generate or nios2-flash-programmer-gui.
#

#
# Converting SOF File: output_files/chris_proj_time_limited.sof to: "../flash/chris_proj_time_limited_EPCS64.flash"
#
sof2flash --input="output_files/chris_proj_time_limited.sof" --output="../flash/chris_proj_time_limited_EPCS64.flash" --epcs --verbose 

#
# Programming File: "../flash/chris_proj_time_limited_EPCS64.flash" To Device: EPCS64
#
nios2-flash-programmer "../flash/chris_proj_time_limited_EPCS64.flash" --base=0x0 --epcs --sidp=0x1820 --id=0xFF --accept-bad-sysid --program --verbose 

#
# Converting ELF File: Qsys/software/sw_design/sw_design.elf to: "../flash/sw_design_EPCS64.flash"
#
elf2flash --input="Qsys/software/sw_design/sw_design.elf" --output="../flash/sw_design_EPCS64.flash" --epcs --after="../flash/chris_proj_time_limited_EPCS64.flash" --verbose 

#
# Programming File: "../flash/sw_design_EPCS64.flash" To Device: EPCS64
#
nios2-flash-programmer "../flash/sw_design_EPCS64.flash" --base=0x0 --epcs --sidp=0x1820 --id=0xFF --accept-bad-sysid --program --verbose 

