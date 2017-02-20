################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/K1921VK01T_init.c \
../src/main.c 

OBJS += \
./src/K1921VK01T_init.o \
./src/main.o 

C_DEPS += \
./src/K1921VK01T_init.d \
./src/main.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"D:\Worcspace\VectorIDE_Examples\Example_LED_blinking\include" -I"C:\Program Files (x86)\Windows Kits\8.1\Include" -I"D:\Vector\VectorIDE\CodeBench" -std=gnu11 -Wa,-adhlns="$@.lst" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


