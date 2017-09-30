################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := clean

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 

# All Target
all: main.axf

# Tool invocations
main.axf: $(OBJS) /home/chris/altera/15.0/embedded/host_tools/mentor/gnu/arm/baremetal/arm-altera-eabi/lib/cycloneV-dk-oc-ram-hosted.ld $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: GCC C Linker'
	arm-altera-eabi-gcc -T "/home/chris/altera/15.0/embedded/host_tools/mentor/gnu/arm/baremetal/arm-altera-eabi/lib/cycloneV-dk-oc-ram-hosted.ld" -o "main.axf" $(OBJS) $(LIBS) $(USER_OBJS)
	@echo 'Finished building target: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS) $(C_DEPS) $(EXECUTABLES) main.axf 
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
