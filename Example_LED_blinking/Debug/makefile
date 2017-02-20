################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := cs-rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include src/subdir.mk
-include asm/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
SECONDARY_FLASH += \
Example_LED_blinking.bin \

SECONDARY_SIZE += \
Example_LED_blinking.siz \


# All Target
all: Example_LED_blinking.elf secondary-outputs

# Tool invocations
Example_LED_blinking.elf: $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: Cross ARM C Linker'
	arm-none-eabi-gcc -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -T "D:\Worcspace\VectorIDE_Examples\Example_LED_blinking\cmd\build.ld" -nodefaultlibs -nostdlib -Xlinker --gc-sections -L"D:\Worcspace\VectorIDE_Examples\Example_LED_blinking\lib" -L"C:\Program Files (x86)\Windows Kits\8.1\Include" -Xlinker -L"D:\Worcspace\VectorIDE_Examples\Example_LED_blinking\cmd" -Wl,-Map,"Example_LED_blinking.map" -o "Example_LED_blinking.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

Example_LED_blinking.bin: Example_LED_blinking.elf
	@echo 'Invoking: Cross ARM GNU Create Flash Image'
	arm-none-eabi-objcopy -O binary "Example_LED_blinking.elf"  "Example_LED_blinking.bin"
	@echo 'Finished building: $@'
	@echo ' '

Example_LED_blinking.siz: Example_LED_blinking.elf
	@echo 'Invoking: Cross ARM GNU Print Size'
	arm-none-eabi-size --format=berkeley "Example_LED_blinking.elf"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(SECONDARY_FLASH)$(SECONDARY_SIZE)$(ASM_DEPS)$(S_UPPER_DEPS)$(C_DEPS) Example_LED_blinking.elf
	-@echo ' '

secondary-outputs: $(SECONDARY_FLASH) $(SECONDARY_SIZE)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
