#commit
vpath %.S nxplib
vpath %.c nxplib nxplib/drivers
vpath %.h nxplib nxplib/drivers nxplib/cminc 

#allow use peripherals lib function
DEFS += -DCPU_LPC54628J512ET180


INCS += -Inxplib -Inxplib/cminc -Inxplib/drivers 

#-Inxplib/power_softabi -Inxplib/power_hardabi

OBJS += nxplib/startup_LPC54628.o system_LPC54628.o
OBJS += nxplib/drivers/fsl_gpio.o nxplib/drivers/fsl_clock.o 
#OBJS += nxplib/drivers/fsl_power.o nxplib/drivers/fsl_clock.o 
OBJS += main.o 

# 使用了编译优化和硬件浮点数
CFLAGS += -mcpu=cortex-m4 -mthumb -Wall 
#CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS += -Os
CFLAGS += -ffunction-sections -fdata-sections

LFLAGS += -mcpu=cortex-m4 -mthumb
#LFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
LFLAGS += -Wl,--gc-sections 


all:$(OBJS)
#	@arm-none-eabi-gcc nxplib/drivers/fsl_clock.c -L -lpower_hardabi -lpower_softabi -o fsl_clock
#	@arm-none-eabi-gcc $(LFLAGS) $^ fsl_clock libpower_hardabi.a libpower_softabi.a -Tnxplib/LPC54628J512_flash.ld -o blink.elf
	@arm-none-eabi-gcc $(LFLAGS) $^ -Tnxplib/LPC54628J512_flash.ld -o blink.elf
	@arm-none-eabi-objcopy -O binary -S blink.elf blink.bin
	@arm-none-eabi-size blink.elf
	@arm-none-eabi-objdump -S blink.elf > blink.dis
	
%.o:%.S
	@arm-none-eabi-gcc $(CFLAGS) -c $< -o $@
%.o:%.c
	@arm-none-eabi-gcc $(CFLAGS) $(DEFS) $(INCS) -c $< -o $@
	
#	@arm-none-eabi-gcc -L nxplib/libs

	
clean:
	@rm -f $(OBJS) *.bin *.elf *.dis

upload:
	@make all
	@JLinkExe jlink.cfg



