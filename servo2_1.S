


#riscv32-unknown-elf-as -g ADC_GCC_ver1.S -o ADC_GCC_ver1.O
#riscv32-unknown-elf-ld -T CH32V003.ld -Map=final.map ADC_GCC_ver1.O
#riscv32-unknown-elf-objcopy -O ihex a.out ADC_GCC_ver1.hex

# new linker version
#.\riscv32-unknown-elf-as -g ADC_GCC_ver1.S -o ADC_GCC_ver1.O
#.\riscv32-unknown-elf-ld -T CH32V003.ld --Map final.map ADC_GCC_ver1.O
#.\riscv32-unknown-elf-objcopy -O ihex a.out ADC_GCC_ver1.hex

# ADC is set to read PC4 for motor position as regular channel
# ADC to read input/target potentiometer is on PA1 as injected channel
# ADC is triggered by PWM signal from timer1 CH2 internally. first pc4 is converted then due to JAUTO bit injected chanel follows automatically
# ADC results stored in RDATAR & IDATAR
# motor controlled by PWM1 on CH1 & CH1N. PC2 & PD0 , value updated by timer1 ISR every 1ms

#TIMER2 Default mapping (CH1/ETR/PD4, CH2/PD3,CH3/PC0, CH4/PD7).
#TIMER1 Default mapping (ETR/PC5, CH1/PD2,CH2/PA1, CH3/PC3, CH4/PC4, BKIN/PC2,CH1N/PD0, CH2N/PA2, CH3N/PD1).
#PD4 - servo output
#PD3 - servo output

#PC4  ADC input
#PC1  I2C SDA
#PC2  I2C CLK
#PD5,PD6 UART output Tx,RX



#PA2 = A0
#PA1 = A1
#PC4 = A2
#PD2 = A3
#PD3 = A4
#PD5 = A5
#PD6 = A6
#PD4 = A7




.equ SRAM_start, 0x20000000
.equ SRAM_end, 0x20000800
.equ STACK, 0x20000800



.equ TIM2_BASE, 0x40000000
.equ W_WDG_BASE, 0x40002C00
.equ I_WDG_BASE, 0x40003000
.equ I2C_BASE, 0x40005400
.equ PWR_BASE, 0x40007000
.equ AFIO_BASE, 0x40010000
.equ EXTI_BASE, 0x40010400
.equ PORTA_BASE, 0x40010800
.equ PORTC_BASE, 0x40011000
.equ PORTD_BASE, 0x40011400
.equ ADC_BASE, 0x40012400
.equ TIM1_BASE, 0x40012C00
.equ SPI_BASE, 0x40013000
.equ USART_BASE, 0x40013800
.equ DMA_BASE, 0x40020000
.equ RCC_BASE, 0x40021000
.equ FLASH_INTERFACE_BASE, 0x40022000
.equ EXTENDED_MEM_BASE, 0x40023800
.equ CORE_PRIVATE_BASE, 0xE0000000
.equ FLASH_BASE, 0x08000000


.equ R32_PWR_CTLR, 0x40007000 	#Power control register
.equ R32_PWR_CSR, 0x40007004 	#Power control/status register
.equ R32_PWR_AWUCSR, 0x40007008 #Auto-wakeup control/status register
.equ R32_PWR_AWUWR, 0x4000700C	#Auto-wakeup window comparison value register
.equ R32_PWR_AWUPSC, 0x40007010 	#Auto-wakeup crossover factor register
.equ R32_RCC_CTLR, 0x40021000 	#Clock control register 0x0000xx83
.equ R32_RCC_CFGR0, 0x40021004 	#Clock configuration register 0 0x00000000
.equ R32_RCC_INTR, 0x40021008 	#Clock interrupt register 0x00000000
.equ R32_RCC_APB2PRSTR, 0x4002100C 	#APB2 peripheral reset register 0x00000000
.equ R32_RCC_APB1PRSTR, 0x40021010 	# APB1 peripheral reset register 0x00000000
.equ R32_RCC_AHBPCENR, 0x40021014 	#AHB peripheral clock enable register 0x00000014
.equ R32_RCC_APB2PCENR, 0x40021018 #APB2 peripheral clock enable register 0x00000000
.equ R32_RCC_APB1PCENR, 0x4002101C 	#APB1 peripheral clock enable register 0x00000000
.equ R32_RCC_RSTSCKR, 0x40021024   	#Control/status register

.equ R16_IWDG_CTLR, 0x40003000 	#Control register 0x0000
.equ R16_IWDG_PSCR, 0x40003004	#Prescaler register 0x0000
.equ R16_IWDG_RLDR, 0x40003008 	#Reload register 0x0FFF
.equ R16_IWDG_STATR, 0x4000300C 	#Status register

.equ R16_WWDG_CTLR, 0x40002C00 	#Control register 0x007F
.equ R16_WWDG_CFGR, 0x40002C04 	#Configuration Register 0x007F
.equ R16_WWDG_STATR, 0x40002C08 	#Status Register

.equ R32_EXTI_INTENR, 0x40010400 	#Interrupt enable register 0x00000000
.equ R32_EXTI_EVENR,  0x40010404 	#Event enable register 0x00000000
.equ R32_EXTI_RTENR, 0x40010408 	#Rising edge trigger enable register 0x00000000
.equ R32_EXTI_FTENR, 0x4001040C 	#Falling edge trigger enable register 0x00000000
.equ R32_EXTI_SWIEVR, 0x40010410 	#Soft interrupt event register 0x00000000
.equ R32_EXTI_INTFR, 0x40010414 	#Interrupt flag register

.equ R32_PFIC_ISR1, 0xE000E000 	#PFIC interrupt enable status register 1
.equ R32_PFIC_ISR2, 0xE000E004 	#PFIC interrupt enable status register 2 
.equ R32_PFIC_IPR1, 0xE000E020 	#PFIC interrupt pending status register 1 
.equ R32_PFIC_IPR2, 0xE000E024 	#PFIC interrupt pending status register 2 
.equ R32_PFIC_ITHRESDR, 0xE000E040 	#PFIC interrupt priority threshold configuration register
.equ R32_PFIC_CFGR, 0xE000E048 	#PFIC interrupt configuration register
.equ R32_PFIC_GISR, 0xE000E04C 	#PFIC interrupt global status register 
.equ R32_PFIC_VTFIDR, 0xE000E050 	#PFIC VTF interrupt ID configuration register
.equ R32_PFIC_VTFADDRR0, 0xE000E060 #PFIC VTF interrupt 0 offset address register
.equ R32_PFIC_VTFADDRR1, 0xE000E064 #PFIC VTF interrupt 1 offset address register
.equ R32_PFIC_IENR1, 0xE000E100	#PFIC interrupt enable setting register 1 
.equ R32_PFIC_IENR2, 0xE000E104 	#PFIC interrupt enable setting register 2 
.equ R32_PFIC_IRER1, 0xE000E180 	#PFIC interrupt enable clear register 1 
.equ R32_PFIC_IRER2, 0xE000E184 	#PFIC interrupt enable clear register 2 
.equ R32_PFIC_IPSR1, 0xE000E200 	#PFIC interrupt pending setting register 1 
.equ R32_PFIC_IPSR2, 0xE000E204 	#PFIC interrupt pending setting register 2 
.equ R32_PFIC_IPRR1, 0xE000E280 	#PFIC interrupt hang clear register 1 
.equ R32_PFIC_IPRR2, 0xE000E284 	#PFIC interrupt hang clear register 2 
.equ R32_PFIC_IACTR1, 0xE000E300 	#PFIC interrupt activation status register1
.equ R32_PFIC_IACTR2, 0xE000E304 	#PFIC interrupt activation status register2
.equ R32_PFIC_IPRIOR1, 0xE000E400 	#PFIC interrupt priority configuration register
.equ R32_PFIC_IPRIOR2, 0xE000E401 	#PFIC interrupt priority configuration register
.equ R32_PFIC_SCTLR, 0xE000ED10 	#PFIC system control register

.equ INTSYSCR, 0x804 		#Interrupt System Control Register
.equ MTVEC, 0x305 		#Exception Entry Base Address Register
.equ DBGMCU_CR, 0x7C0  		#Debug MCU Configuration Register (CSR)
 
.equ R32_STK_CTLR, 0xE000F000 	#System count control register 
.equ R32_STK_SR, 0xE000F004 	#System count status register 
.equ R32_STK_CNTR, 0xE000F008	# System counter low register 
.equ R32_STK_CMPR, 0xE000F010 	#Counting comparison low register


.equ R32_GPIOA_CFGLR, 0x40010800 	#PA port configuration register low 0x44444444
.equ R32_GPIOC_CFGLR, 0x40011000 	#PC port configuration register low 0x44444444
.equ R32_GPIOD_CFGLR, 0x40011400 	#PD port configuration register low 0x44444444
.equ R32_GPIOA_INDR, 0x40010808 	#PA port input data register 0x0000XXXX
.equ R32_GPIOC_INDR, 0x40011008 	#PC port input data register 0x0000XXXX
.equ R32_GPIOD_INDR, 0x40011408 	#PD port input data register 0x0000XXXX
.equ R32_GPIOA_OUTDR, 0x4001080C 	#PA port output data register 0x00000000
.equ R32_GPIOC_OUTDR, 0x4001100C 	#PC port output data register 0x00000000
.equ R32_GPIOD_OUTDR, 0x4001140C 	#PD port output data register 0x00000000
.equ R32_GPIOA_BSHR, 0x40010810 	#PA port set/reset register 0x00000000
.equ R32_GPIOC_BSHR, 0x40011010 	#PC port set/reset register 0x00000000
.equ R32_GPIOD_BSHR, 0x40011410 	#PD port set/reset register 0x00000000
.equ R32_GPIOA_BCR, 0x40010814 	#PA port reset register 0x00000000
.equ R32_GPIOC_BCR, 0x40011014 	#PC port reset register
.equ R32_GPIOD_BCR, 0x40011414 	#PD port reset register 0x00000000
.equ R32_GPIOA_LCKR, 0x40010818 	#PA port configuration lock register 0x00000000
.equ R32_GPIOC_LCKR, 0x40011018 	#PC port configuration lock register 0x00000000
.equ R32_GPIOD_LCKR, 0x40011418 	#PD port configuration lock register 
.equ R32_AFIO_PCFR1, 0x40010004	#AFIO Remap Register 1
.equ R32_AFIO_EXTICR, 0x40010008 	#External interrupt configuration register 1

.equ R32_DMA_INTFR, 0x40020000 	#DMA interrupt status register 0x00000000
.equ R32_DMA_INTFCR, 0x40020004 	#DMA interrupt flag clear register 0x00000000
.equ R32_DMA_CFGR1, 0x40020008 	#DMA channel 1 configuration register 0x00000000
.equ R32_DMA_CNTR1, 0x4002000C 	#DMA channel 1 number of data register
.equ R32_DMA_PADDR1, 0x40020010 	#DMA channel 1 peripheral address register 0x00000000
.equ R32_DMA_MADDR1, 0x40020014 	#DMA channel 1 memory address register 0x00000000
.equ R32_DMA_CFGR2, 0x4002001C 	#DMA channel 2 configuration register 0x00000000
.equ R32_DMA_CNTR2, 0x40020020 	#DMA channel 2 number of data register 0x00000000
.equ R32_DMA_PADDR2, 0x40020024 	#DMA channel 2 peripheral address register 0x00000000
.equ R32_DMA_MADDR2, 0x40020028 	#DMA channel 2 memory address register 0x00000000
.equ R32_DMA_CFGR3, 0x40020030 	#DMA channel 3 configuration register 0x00000000
.equ R32_DMA_CNTR3, 0x40020034 	#DMA channel 3 number of data register 0x00000000
.equ R32_DMA_PADDR3, 0x40020038 	#DMA channel 3 peripheral address register 0x00000000
.equ R32_DMA_MADDR3, 0x4002003C 	#DMA channel 3 memory address register 0x00000000
.equ R32_DMA_CFGR4, 0x40020044 	#DMA channel 4 configuration register 0x00000000
.equ R32_DMA_CNTR4, 0x40020048 	#DMA channel 4 number of data register 0x00000000
.equ R32_DMA_PADDR4, 0x4002004C 	#DMA channel 4 peripheral address register 0x00000000
.equ R32_DMA_MADDR4, 0x40020050 	#DMA channel 4 memory address register 0x00000000
.equ R32_DMA_CFGR5, 0x40020058	#DMA channel 5 configuration register 0x00000000
.equ R32_DMA_CNTR5, 0x4002005C 	#DMA channel 5 number of data register 0x00000000
.equ R32_DMA_PADDR5, 0x40020060 	#DMA channel 5 peripheral address register 0x00000000
.equ R32_DMA_MADDR5, 0x40020064 	#DMA channel 5 memory address register 0x00000000
.equ R32_DMA_CFGR6, 0x4002006C 	#DMA channel 6 configuration register 0x00000000
.equ R32_DMA_CNTR6, 0x40020070 	#DMA channel 6 number of data register 0x00000000
.equ R32_DMA_PADDR6, 0x40020074 	#DMA channel 6 peripheral address register 0x00000000
.equ R32_DMA_MADDR6, 0x40020078 	#DMA channel 6 memory address register 0x00000000
.equ R32_DMA_CFGR7, 0x40020080 	#DMA channel 7 configuration register 0x00000000
.equ R32_DMA_CNTR7, 0x40020084 	#DMA channel 7 number of data register 0x00000000
.equ R32_DMA_PADDR7, 0x40020088 	#DMA channel 7 peripheral address register 0x00000000
.equ R32_DMA_MADDR7, 0x4002008C 	#DMA channel 7 memory address register


.equ R32_ADC_STATR, 0x40012400 	#ADC status register 0x00000000
.equ R32_ADC_CTLR1, 0x40012404 	#ADC control register 1 0x00000000
.equ R32_ADC_CTLR2, 0x40012408 	#ADC control register 2 0x00000000
.equ R32_ADC_SAMPTR1, 0x4001240C 	#ADC sample time register 1 0x00000000
.equ R32_ADC_SAMPTR2, 0x40012410 	#ADC sample time register 2 0x00000000
.equ R32_ADC_IOFR1, 0x40012414 	#ADC injected channel data offset register 1 0x00000000
.equ R32_ADC_IOFR2, 0x40012418 	#ADC injected channel data offset register 2 0x00000000
.equ R32_ADC_IOFR3, 0x4001241C 	#ADC injected channel data offset register 3 0x00000000
.equ R32_ADC_IOFR4, 0x40012420 	#ADC injected channel data offset register 4 0x00000000
.equ R32_ADC_WDHTR, 0x40012424 	#ADC watchdog high threshold register 0x00000000
.equ R32_ADC_WDLTR, 0x40012428 	#ADC watchdog low threshold register 0x00000000
.equ R32_ADC_RSQR1, 0x4001242C 	#ADC regular sequence register 1 0x00000000
.equ R32_ADC_RSQR2, 0x40012430 	#ADC regular sequence register 2 0x00000000
.equ R32_ADC_RSQR3, 0x40012434 	#ADC regular sequence register 3 0x00000000
.equ R32_ADC_ISQR, 0x40012438 	#ADC injected sequence register 0x00000000
.equ R32_ADC_IDATAR1, 0x4001243C 	#ADC injected data register 1 0x00000000
.equ R32_ADC_IDATAR2, 0x40012440 	#ADC injected data register 2 0x00000000
.equ R32_ADC_IDATAR3, 0x40012444 	#ADC injected data register 3 0x00000000
.equ R32_ADC_IDATAR4, 0x40012448 	#ADC injected data register 4 0x00000000
.equ R32_ADC_RDATAR, 0x4001244C 	#ADC regular data register 0x00000000
.equ R32_ADC_DLYR, 0x40012450 	#ADC delayed data register


.equ R16_TIM1_CTLR1, 0x40012C00 	#Control register 1 0x0000
.equ R16_TIM1_CTLR2, 0x40012C04 	#Control register 2 0x0000
.equ R16_TIM1_SMCFGR, 0x40012C08 	#Slave mode control register 0x0000
.equ R16_TIM1_DMAINTENR, 0x40012C0C 	#DMA/interrupt enable register 0x0000
.equ R16_TIM1_INTFR, 0x40012C10 	#Interrupt status register 0x0000
.equ R16_TIM1_SWEVGR, 0x40012C14 	#Event generation register 0x0000
.equ R16_TIM1_CHCTLR1, 0x40012C18 	#Compare/capture control register 1 0x0000
.equ R16_TIM1_CHCTLR2, 0x40012C1C 	#Compare/capture control register 2 0x0000
.equ R16_TIM1_CCER, 0x40012C20 	#Compare/capture enable register 0x0000
.equ R16_TIM1_CNT, 0x40012C24 	#Counters 0x0000
.equ R16_TIM1_PSC, 0x40012C28 	#Counting clock prescaler 0x0000
.equ R16_TIM1_ATRLR, 0x40012C2C 	#Auto-reload value register 0x0000
.equ R16_TIM1_RPTCR, 0x40012C30 	#Recurring count value register 0x0000
.equ R16_TIM1_CH1CVR, 0x40012C34 	#Compare/capture register 1 0x0000
.equ R16_TIM1_CH2CVR, 0x40012C38 	#Compare/capture register 2 0x0000
.equ R16_TIM1_CH3CVR, 0x40012C3C 	#Compare/capture register 3 0x0000
.equ R16_TIM1_CH4CVR, 0x40012C40 	#Compare/capture register 4 0x0000
.equ R16_TIM1_BDTR, 0x40012C44 	#Brake and deadband registers 0x0000
.equ R16_TIM1_DMACFGR, 0x40012C48 	#DMA control register 0x0000
.equ R16_TIM1_DMAADR, 0x40012C4C 	#DMA address register for continuous mode


.equ R16_TIM2_CTLR1, 0x40000000 	#TIM2 control register1 0x0000
.equ R16_TIM2_CTLR2, 0x40000004 	#TIM2 control register2 0x0000
.equ R16_TIM2_SMCFGR, 0x40000008 	#TIM2 Slave mode control register 0x0000
.equ R16_TIM2_DMAINTENR, 0x4000000C 	#TIM2 DMA/interrupt enable register
.equ R16_TIM2_INTFR, 0x40000010 	#TIM2 interrupt status register 0x0000
.equ R16_TIM2_SWEVGR, 0x40000014 	#TIM2 event generation register 0x0000
.equ R16_TIM2_CHCTLR1, 0x40000018 	#TIM2 compare/capture control register1 0x0000
.equ R16_TIM2_CHCTLR2, 0x4000001C 	#TIM2 compare/capture control register2 0x0000
.equ R16_TIM2_CCER, 0x40000020 	#TIM2 compare/capture enable register 0x0000
.equ R16_TIM2_CNT, 0x40000024 	#TIM2 counter 0x0000
.equ R16_TIM2_PSC, 0x40000028 	#TIM2 count clock prescaler 0x0000
.equ R16_TIM2_ATRLR, 0x4000002C 	#TIM2 auto-reload register 0x0000
.equ R16_TIM2_CH1CVR, 0x40000034 	#TIM2 compare/capture register1 0x0000
.equ R16_TIM2_CH2CVR, 0x40000038 	#TIM2 compare/capture register2 0x0000
.equ R16_TIM2_CH3CVR, 0x4000003C 	#TIM2 compare/capture register3 0x0000
.equ R16_TIM2_CH4CVR, 0x40000040 	#TIM2 compare/capture register4 0x0000
.equ R16_TIM2_DMACFGR, 0x40000048 	#TIM2 DMA control register 0x0000
.equ R16_TIM2_DMAADR, 0x4000004C 	#TIM2 DMA address register in continuous mode
  

.equ R32_USART_STATR, 0x40013800 	#UASRT status register 0x000000C0
.equ R32_USART_DATAR, 0x40013804 	#UASRT data register 0x000000XX
.equ R32_USART_BRR, 0x40013808 	#UASRT baud rate register 0x00000000
.equ R32_USART_CTLR1, 0x4001380C 	#UASRT control register 1 0x00000000
.equ R32_USART_CTLR2, 0x40013810 	#UASRT control register 2 0x00000000
.equ R32_USART_CTLR3, 0x40013814 	#UASRT control register 3 0x00000000
.equ R32_USART_GPR, 0x40013818 	#UASRT protection time and prescaler register


.equ R16_I2C_CTLR1, 0x40005400 	#I2C control register 1 0x0000
.equ R16_I2C_CTLR2, 0x40005404 	#I2C control register 2 0x0000
.equ R16_I2C_OADDR1, 0x40005408 	#I2C address register 1 0x0000
.equ R16_I2C_OADDR2, 0x4000540C 	#I2C address register 2 0x0000
.equ R16_I2C_DATAR,  0x40005410 	#I2C data register 0x0000
.equ R16_I2C_STAR1,  0x40005414 	#I2C status register 1 0x0000
.equ R16_I2C_STAR2,  0x40005418 	#I2C status register 2 0x0000
.equ R16_I2C_CKCFGR, 0x4000541C 	#I2C clock register

.equ R16_SPI_CTLR1, 0x40013000 	#SPI Control register1 0x0000
.equ R16_SPI_CTLR2, 0x40013004 	#SPI Control register2 0x0000
.equ R16_SPI_STATR, 0x40013008 	#SPI Status register 0x0002
.equ R16_SPI_DATAR, 0x4001300C 	#SPI Data register 0x0000
.equ R16_SPI_CRCR,  0x40013010 	#SPI Polynomial register 0x0007
.equ R16_SPI_RCRCR, 0x40013014 	#SPI Receive CRC register 0x0000
.equ R16_SPI_TCRCR, 0x40013018 	#SPI Transmit CRC register 0x0000
.equ R16_SPI_HSCR,  0x40013024 	#SPI High-speed control register

.equ R16_ESIG_FLACAP, 0x1FFFF7E0 	#Flash capacity register 0xXXXX
.equ R32_ESIG_UNIID1, 0x1FFFF7E8 	#UID register 1 0xXXXXXXXX
.equ R32_ESIG_UNIID2, 0x1FFFF7EC 	#UID register 2 0xXXXXXXXX
.equ R32_ESIG_UNIID3,  0x1FFFF7F0 	#UID register 3 

.equ R32_FLASH_ACTLR, 0x40022000 	#Control register
.equ R32_FLASH_KEYR,  0x40022004 	#FPEC key register X
.equ R32_FLASH_OBKEYR, 0x40022008 	#OBKEY register X
.equ R32_FLASH_STATR, 0x4002200C 	#Status register 0x00008000
.equ R32_FLASH_CTLR,  0x40022010 	#Configuration register 0x00008080
.equ R32_FLASH_ADDR, 0x40022014 	#Address register X
.equ R32_FLASH_OBR,  0x4002201C 	#Select word register 0x03FFFFFE
.equ R32_FLASH_WPR,  0x40022020 	#Write protection register 0xFFFFFFF
.equ R32_FLASH_MODEKEYR,  0x40022024 	#Extended key register X
.equ R32_FLASH_BOOT_MODEKEYR,  0x40022028 #Unlock BOOT key register

.equ R32_EXTEN_CTR, 0x40023800 	#Configure extended control registers

.equ PFIC_KEY1, 0xFA050000
.equ PFIC_KEY2, 0xBCAF0000
.equ PFIC_KEY3, 0xBEEF0000
.equ mstatus, 0x300
.equ mtvec, 0x305
.equ intsyscr, 0x804
.equ mepc, 0x341

.equ  SYSTICK_SR_CNTIF, (1<<0)
.equ  SYSTICK_CTLR_STE , (1<<0)
.equ  SYSTICK_CTLR_STIE, (1<<1)
.equ  SYSTICK_CTLR_STCLK, (1<<2)
.equ  SYSTICK_CTLR_STRE,  (1<<3)
.equ  SYSTICK_CTLR_SWIE, (1<<31) 

.equ data_command2 , 0x0d               #0b00001101# data control nibble , 1101  = 0x0D   - EN goes hi=1
.equ data_command3 , 0xf9		#0b00001001# data control nibble , 1011  = 0x0B   - EN goes low=0
.equ inst_command2 , 0x0C               #0b00001100# instruction control nibble ,  led on,EN hi , rs/RW 0    = 1100   = 0x0C
.equ inst_command3 , 0xf8		#0b00001000# instruction control nibble  , led on, EN lo ,rs/rw 0    = 1000   = 0x08
.equ LCDWAD , 0x4E 			# 1602 LCD address

.equ Kp, 0x00008000      # 0.5 × 65536
.equ Ki, 0x00000CCD      # 0.05 × 65536
.equ Kd, 0x0000199A      # 0.1 × 65536
###############################
.equ buffer,   0x20000004
.equ buffer1,  0x20000008
.equ state , 0x2000000C
.equ input_count,  0x20000010
.equ kd_gain,  0x20000014
.equ fraction,  0x20000018		# stores 1 second measure window overflow for slow signals
.equ fraction2,  0x2000001C
.equ result_lo,  0x20000020
.equ result_hi,  0x20000024
.equ modulo ,  0x20000028 
.equ scratch,  0x2000002C
.equ result1,  0x20000030		# 10 bytes used by print function from 0(mem)
.equ result2,  0x20000034		# till 9(mem) , 2 bytes in mem1
.equ dividend , 0x20000038
.equ divisor, 0x2000003C
.equ scratchpad, 0x20000040
.equ last_error, 0x20000044
.equ kd_gain,	0x20000048
.equ ki_gain, 0x2000004C
.equ kp_gain,0x20000058
.equ i_accum,0x2000005C
.equ mem,0x20000060








.macro push val
  addi sp, sp, -4
  sw \val, 0(sp)
.endm

.macro pop val
  lw \val, 0(sp)
  addi sp, sp, 4
.endm

.macro pos x y
  addi sp,sp,-8
  sw x6,0(sp)
  sw x7,4(sp)
  li x6,\y
  li x7,\x
  call posi
  lw x7,4(sp)
  lw x6,0(sp)
  addi sp,sp,8
.endm

.macro string address
  addi sp,sp,-4
  sw a2,0(sp)
  la a2,\address
  call string_reader
  lw a2,0(sp)
  addi sp,sp,4
.endm

.macro micros val
  addi sp,sp,-4
  sw t1,0(sp)
  li t1,\val
  call delayus
  lw t1,0(sp)
  addi sp,sp,4
.endm

.macro debug tp
  addi sp,sp,-8
  sw a5,0(sp)
  sw gp,4(sp)
  la a5, result_lo
  mv gp,\tp
  sw gp, 0(a5)
  call convert_to_decimal_signed
  pos 0,0
  call displayresult2		# display value in LCD
  call delay1S			# delay 1 second
  lw gp,4(sp)
  lw a5,0(sp)
  addi sp,sp,8
.endm

.align 9
vtable:
  j start		#  
.align 2
  .word   0x00000000 # RESERVED 1
  .word   NMI_IRQhandler
  .word   HardFault_IRQhandler
  .word   0x00000000 # RESERVED 4
  .word   0x00000000 # RESERVED 5
  .word   0x00000000 # RESERVED 6
  .word   0x00000000 # RESERVED 7
  .word   0x00000000 # RESERVED 8
  .word   0x00000000 # RESERVED 9
  .word   0x00000000 # RESERVED 10
  .word   0x00000000 # RESERVED 11
  .word   SysTick_IRQhandler	#; place the address of the mtime ISR subroutine in the vector table position 7,assembler will store isr address here, longs 0x00000000 # RESERVED 12	
  .word   0x00000000 # RESERVED 13
  .word   SW_Software_IRQhandler
  .word   0x00000000 # RESERVED 15
  .word   WWDG_IRQhandler
  .word   PVD_IRQhandler
  .word   FLASH_IRQhandler
  .word   RCC_IRQhandler
  .word   EXTI7_0_IRQhandler
  .word   AWU_IRQhandler
  .word   DMA1_CH1_IRQhandler
  .word   DMA1_CH2_IRQhandler
  .word   DMA1_CH3_IRQhandler
  .word   DMA1_CH4_IRQhandler
  .word   DMA1_CH5_IRQhandler
  .word   DMA1_CH6_IRQhandler
  .word   DMA1_CH7_IRQhandler
  .word  ADC1_IRQhandler				# ADC1 interrupt vector
  .word  I2C1_EV_IRQhandler
  .word  I2C1_ER_IRQhandler
  .word  USART1_IRQhandler
  .word  SPI1_IRQhandler
  .word  TIM1BRK_IRQhandler
  .word  TIM1UP_IRQhandler
  .word  TIM1TRG_COM_IRQhandler
  .word  TIM1CC_IRQhandler
  .word  TIM2_IRQhandler



.text
.section .isr_vectors
  .weak   NMI_IRQhandler
  .weak   HardFault_IRQhandler
  .weak   SysTick_IRQhandler	#; place the address of the mtime ISR subroutine in the vector table position 7,assembler will store isr address here, longs 0x00000000 # RESERVED 12	
  .weak   SW_Software_IRQhandler
  .weak   WWDG_IRQhandler
  .weak   PVD_IRQhandler
  .weak   FLASH_IRQhandler
  .weak   RCC_IRQhandler
  .weak   EXTI7_0_IRQhandler
  .weak   AWU_IRQhandler
  .weak   DMA1_CH1_IRQhandler
  .weak   DMA1_CH2_IRQhandler
  .weak   DMA1_CH3_IRQhandler
  .weak   DMA1_CH4_IRQhandler
  .weak   DMA1_CH5_IRQhandler
  .weak   DMA1_CH6_IRQhandler
  .weak   DMA1_CH7_IRQhandler
  .weak  ADC1_IRQhandler				# ADC1 interrupt vector
  .weak  I2C1_EV_IRQhandler
  .weak  I2C1_ER_IRQhandler
  .weak  USART1_IRQhandler
  .weak  SPI1_IRQhandler
  .weak  TIM1BRK_IRQhandler
  .weak  TIM1UP_IRQhandler
  .weak  TIM1TRG_COM_IRQhandler
  .weak  TIM1CC_IRQhandler
  .weak  TIM2_IRQhandler


.align 2
.text
.global start
start:

    	li sp, STACK			# load stack pointer with stack end address
	 
    	la t0, vtable			#BASEADDR[31:2],The interrupt vector table base address,which needs to be 1KB aligned
    	ori t0, t0, 3			#BASEADDR[31:2],1: Identify by absolute address,1: Address offset based on interrupt number *4
    	csrrw zero, mtvec,t0		# write t0 mtvec
   	la t0,main
	csrw	mepc,t0
          				#csrw	mepc,t0 :mepc updated with address of main
	mret

  
.align 4

main:        


#Enable GPIO clocks & AFIO in APB2 clock register
        
    	la x10,R32_RCC_APB2PCENR	# load address of APB2PCENR register to x10 ,for enabling GPIO A,D,C peripherals
	lw x11,0(x10)			# load contents from peripheral register R32_RCC_APB2PCENR pointed by x10
	li x7,((1<<2)|(1<<4)|(1<<5)|(1<<0)|(1<<14)|(1<<9)|(1<<11))	# 1<<IOPA_EN,1<<IOPC_EN,1<<IOPD_EN,1<<AFIOEN,1<<USART ,1<<ADC enable port A,C,D and AFIO functions,1<<TIM1
	or x11,x11,x7			# or values 
	sw x11,0(x10)			# store modified enable values in R32_RCC_APB2PCENR
	la x10,R32_RCC_APB1PCENR
	lw x11,0(x10)
	li x7,((1<<0)|(1<<21))
	or x11,x11,x7			# timer2 clock enable & I2c
	sw x11,0(x10)
#Enable ADC prescaler in clock configuration register
	la x10,R32_RCC_CFGR0
	lw x11,0(x10)
	li x7,(8<<11)			# 0b01000 ADC prescalar ahb/4 = 8/4 = 2mhz
	or x11,x11,x7
	sw x11,0(x10)

#configure GPIOA
	li x10,R32_GPIOA_CFGLR				# load pointer x10 with address of R32_GPIOA_CFGLR , GPIO configuration register
	lw x11,0(x10)					# load contents from register pointed by x10
	li x7,~(0xf<<4)					# clear pa1 for ADC analog
	and x11,x11,x7					# clear pa1
	sw x11,0(x10)		
 

#configure GPIOD 
	li x10,R32_GPIOD_CFGLR				# load pointer x10 with address of R32_GPIOD_CFGLR , GPIO configuration register
	lw x11,0(x10)					# load contents from register pointed by x10
	li x7,~((0xf<<0)|(0xf<<8)|(0xf<<16))		# clear pd0,pd2 we need to setup for pwm on CH1 & CH1N , pd4 for other pushull apps
	and x11,x11,x7					# clear pd0,pd2,pd4 mode and cnf bits for selected pin D3
	li x7,((0xB<<0)|(0xB<<8)|(0x3<<16))		# pd0,pd2 =  multiplex pushpull for ch1 pwm capture compare output,pd4 pushpull
	or x11,x11,x7					# OR value to register
	sw x11,0(x10)					# store in R32_GPIOD_CFGLR

#configure GPIO PortC as multiplex open drain output for I2C
	la x10,R32_GPIOC_CFGLR 				# load pointer x10 with address of R32_GPIOC_CFGLR , I2C SDA & SCL is on portC PC1,PC2
	lw x11,0(x10) 					# load contents from register pointed by x10
	li x7,~((0xf<<4)|(0xf<<8)|(0xf<<16)) 		# clear pc1,pc2, we need to setup PC1 & PC2 for I2C ,PC4 for adc
	and x11,x11,x7 					# clear  mode and cnf bits for selected pin C1,C2
	li x7,((13<<4)|(13<<8)) 			# PC1 = multiplex open drain output 10mhz ,PC2= multiplex open drain output 10mhz, 0b1101,PC4 =0b0000 analog input adc 
	or x11,x11,x7 					# OR value to register
	sw x11,0(x10) 					# store in R32_GPIOC_CFGLR

#disable ADC before configuration
	la x10,R32_ADC_CTLR2
	lw x11,0(x10)
	li x7,0xfffffffe				#disable ADON bit , 0 written in 0bit
	and x11,x11,x7
	sw x11,0(x10)

#set sequence of conversion channel
	la x10,R32_ADC_RSQR3				# sequence register, if multiple sensors used we can determine the order of conversion
	lw x11,0(x10)
	li x7,(2<<0)					# AIN2 , PC4 adc channel is written to sequence 1 (only one rule channel in this project)	
	or x11,x11,x7
	sw x11,0(x10)

# Link Timer 1 CH2 to ADC Trigger ---
	la x10, R32_ADC_CTLR2
	lw x11, 0(x10)
# 1. Select Trigger Source (EXTSEL bits 19:17)		# For CH32V003: 010 = Timer 1 event Channel 2 
	li x7, (2 << 17)  				# 010<<17    ADC starts conversion based on a rising signal event on timer1 CH2  
	or x11, x11, x7
# 2. Enable External Trigger (EXTTRIG bit 20)
	li x7, (1 << 20)				# switch on external trigger
	or x11, x11, x7
	sw x11, 0(x10)
# 3. Setup Injected Sequence (PA1) ---			# we use injection channel to read user input to avoid DMA use , result in IDATAR
    	la x10, R32_ADC_ISQR
    	li x11, (0 << 21)|(1 << 15)           		# JSQ4 = 1 (Channel 1: PA1)# For a 1-channel injected sequence,# the channel number goes in JSQ4. 
	sw x11, 0(x10)
#set sampling cycles
	la x10,R32_ADC_SAMPTR2				# takes sampling cycles for each measurement
	lw x11,0(x10)
	li x7,((1<<3)|(1<<6))				# 0b001 is 9 cycles for AIN1,AIN2	
	or x11,x11,x7
	sw x11,0(x10)
# enable injection after regular conversion
	la x10,R32_ADC_CTLR1
	lw x11,0(x10)
	li x7,(1<<10)					# JAUTO bit enable to start injection after rule chanel automatically
	or x11,x11,x7
	sw x11,0(x10)
#enable adc in control register2
	la x10,R32_ADC_CTLR2
	lw x11,0(x10)
	li x7,(1<<0)					#   ADON 
	or x11,x11,x7
	sw x11,0(x10)
#reset calibrate ADC					# ADC to be calibrated to correct any offset
	la x10,R32_ADC_CTLR2
	lw x11,0(x10)
	li x7,(1<<3)					# reset calibration	
	or x11,x11,x7
	sw x11,0(x10)
check1:
	la x10,R32_ADC_CTLR2
	lw x11,0(x10)
	andi x11,x11,(1<<3)
	bnez x11,check1

# calibrate ADC
	la x10,R32_ADC_CTLR2
	lw x11,0(x10)
	li x7,(1<<2)					# start calibration	
	or x11,x11,x7
	sw x11,0(x10)
check2:
	la x10,R32_ADC_CTLR2
	lw x11,0(x10)
	andi x11,x11,(1<<2)
	bnez x11,check2
############
#I2C0 configuration 
	la x10,R32_RCC_APB1PRSTR 	# set pointer to clock control  peripheral reset register 
	lw x11,0(x10) 			# load contents to x11
	li x7,(1<<21) 			# shift 1 to 21st bit position
	or x11,x11,x7 			# OR with x11
	sw x11,0(x10) 			# set bit 21 of R32_RCC_APB1PRSTR to reset I2C peripheral
	not x7,x7 			# invert values in x7
	and x11,x11,x7 			# and x11 to write a 0 in 21st bit
	sw x11,0(x10) 			# store 0 in 21st bit to restart i2c engine

	la x10,R16_I2C_CTLR2 		# set clock in control 2 register
    	lh x11,0(x10) 			# copy contents of R16_I2C_CTLR2 to x11
	li x7,0xffffffc0 		# clear frequency bits 0-5 with bit mask 0xffffffc0
	and x11,x11,x7 			# AND will clear bit 0-5
    	li x7,(8<<0) 			# 8Mhz I2C clock .default 24Mhz HSI/3 =8Mhz APB clock
    	or x11,x11,x7 			# store APB clock frequency in bit 0-5
	sh x11,0(x10) 			# store back in R16_I2C_CTLR2
    	la x10,R16_I2C_CKCFGR 		# set pointer to I2C clockregister
    	lh x11,0(x10) 			# copy values to x11 from above register
	li x7,0xfffff000 		# clear CCR bits 0-11 with bitmask 0xfffff000
	and x11,x11,x7 			# ANDing clears bit 0-11 in x11 register
	li x7,(40<<0) 			# CCR = t(rscl)+t(wsclh)/tpclk1 = 1000+4000/125 =40 , or (8000000/2*100000)=40 , PCLK/2*100Khz =CCR
    	or x11,x11,x7 			# store calculated CCR (data sheet)in x11 by OR
	sh x11,0(x10) 			# store back in peripheral register
	la x10,R16_I2C_CTLR1 		# set pointer to I2C control register 1
	lh x11,0(x10) 			# copy contents
	li x7,(1<<0) 			# 1<<PE = 1<<0 enable bit is bit0,1<<10 is ack enable bit
	or x11,x11,x7 			# OR enable bit to x11
	sh x11,0(x10) 			# store half word in control register 1
	la x10,R16_I2C_CTLR1 		# set pointer to I2C control register 1
	lh x11,0(x10) 			# copy contents
	li x7,(1<<10) 			# 1<<10 is ack enable bit
	or x11,x11,x7 			# OR ACK enable bit to x11
	sh x11,0(x10) 			# store half word in control register 1
###############################################################################
# load PID gain factor in SRAM
	li a0,buffer
	sw zero,0(a0)
	la t0,kp_gain
	li t1,Kp
	sw t1,0(t0)
	la t0,ki_gain
	li t1,Ki
	sw t1,0(t0)
	la t0,kd_gain
	li t1,Kd
	sw t1,0(t0)

#####################################################################
timer1_for_10ms:
	la x10,R16_TIM1_PSC
	li x11,7			# fck_PSC/PSC[15:0]+1,8MHz/7+1 =1000000 (1Mhz) = 1000000count/sec
	sw x11,0(x10)
	la x10,R16_TIM1_ATRLR
	li x11,1000			# max reload every 1ms  (frequency = 1000000/1000 =1000hZ)1000000count/1000ms =1000count/1ms
	sw x11,0(x10)	
#init PWM
	la x10,R16_TIM1_CH1CVR
	li x11,400			# start with 0 pwm,  each count is = 0.1% duty cycle
	sw x11,0(x10)
	la x10,R16_TIM1_CHCTLR1
	lw x11,0(x10)
	li x7,(6<<4)|(1<<3)		# CH1 mode-1(0b110=6), CH1 output compare preload enable OC2PE to reduce jitter,
	or x11,x11,x7
	sw x11,0(x10)

# Setup Channel 2 as the ADC Trigger .Phase Delay to avoid motor noise interference---
	la x10, R16_TIM1_CH2CVR
	li x11, 800             	# count for when ADC trigger is issued
	sw x11, 0(x10)
# for ADC trigger signal
	la x10, R16_TIM1_CHCTLR1
	lw x11, 0(x10)
	li x7,(7<<12)         		# OC2M = 0b111=7(PWM Mode 2) for a clean rising edge when compare match counter
	or x11, x11, x7
	sw x11, 0(x10)

	la t0,R16_TIM1_CCER
	lw x11,0(t0)	
	li x7,(1<<4)			# enable CC2E bit for output on chanel2, if not enabled no signal from timer on chanel2
	or x11,x11,x7
	sw x11,0(t0)

	la x10,R16_TIM1_DMAINTENR
	lw x11,0(x10)
	li x7,(1<<0)			# enable update interrupt
	or x11,x11,x7
	sw x11,0(x10)
	la x10,R16_TIM1_CTLR1
	lw x11,0(x10)
	la x7,((0<<1)|(1<<2)|(1<<7))	# UDIS =0 ,URS =1,ARPE=1,
	or x11,x11,x7
	sw x11,0(x10)
	la x10,R16_TIM1_SWEVGR
	lw x11,0(x10)
	li x7,(1<<0)			# 1<<UG, generate update event to load all values immediately
	or x11,x11,x7
	sw x11,0(x10)
	la x10,R16_TIM1_INTFR
	lw x11,0(x10)
	li x7,0xFFFFFFFA		# 0<<UIF  clear update interrupt flag
	and x11,x11,x7
	sw x11,0(x10)

	la x10,R16_TIM1_BDTR
	lw x11,0(x10)
	li x7,(1<<15)			# enable MoE
	ori x7, x7, 160        		# Add 20us Dead-time (DTG bits 0-7),prevents shooy through short circuit. both outputs off befors flipping
	or x11,x11,x7
	sw x11,0(x10)

	la x10,R16_TIM1_CTLR1
	lw x11,0(x10)
	ori x11,x11,(1<<0)		# enable timer 1
	sw x11,0(x10)
PFIC_CONFIG:
	la x10,R32_PFIC_CFGR		# reset core PFIC register for interrupts
	lw x11,0(x10)
	li x7,((PFIC_KEY3<<16)|(1<<7))	# key3  and SYSRESET , reference manual tells to do it
	or x11,x11,x7
	sw x11,0(x10)			# store back new values
	la x10,R32_PFIC_IENR2		# PFIC Interrupt Enable in core PFIC
	lw x11,0(x10)
	li x7,(1<<3)			# enabled  TIM1 update interrupts in PFIC
	or x11,x11,x7
	sw x11,0(x10)			# store back new values


######################################################


##########################################################################
	call I2C_START			# start sequence sent oon I2C bus
	la x15,LCDWAD			# load LCD address for write
	call SEND_ADDRESS		# send LCD address
	call LCD_INIT			# call LCD initialization routine

	call delay1S			# 1 second delay

	string name			# transmit name to LCD , testing display
        call delay1S
	call cleardisplay		# clear lcd screen

# enabling GLOBAL INTERRUPTS
	li t0, 0x88			# load MPIE and MIE bits , 1<<MIE in mstatus is enabling GLOBAL INTERRUPTS
	csrw mstatus,t0 		# csrrw the values in t0,



itr: 	
			
	j itr				# waiting in tight loop till interrupt fires , ADC measurement and motor control in ISR every 1ms

	

###########################################################
#################

TIM1UP_IRQhandler:
	addi sp,sp,-60    		# push all registers
	sw x15,56(sp)
	sw x14,52(sp)
	sw x13,48(sp)
	sw x12,44(sp)
	sw x11,40(sp)
	sw x10,36(sp)
	sw x9,32(sp)
	sw x8,28(sp)
	sw x7,24(sp)
	sw x6,20(sp)
	sw x5,16(sp)
	sw x4,12(sp)
	sw x3,8(sp)
	sw x2,4(sp)
	sw x1,0(sp)

######################################################
#la t0,R32_ADC_STATR
#lw t0,0(t0)
#la a5, result_lo
#sw t0, 0(a5)
#call convert_to_decimal_signed
#pos 0,0
#call displayresult2		# display value in LCD
#call delay1S			# delay 1 second
#######################################################
check_Radc_ready:
    	la x10, R32_ADC_STATR       	# Load ADC Status Register
    	lw x11, 0(x10)
    	andi x11, x11, (1 << 1)     	# Bit 1 is JEOC (End of inject Conversion is last to finish)
    	beqz x11, check_Radc_ready   	# If NOT ready, wait (should be instant)
# Clear flags (write 0 to clear)
    	#li   x7, ~(1<<1) 		# clear EOC 
	#and x11,x11,x7
    	#sw   x11, 0(x10)
	la x10, R32_ADC_RDATAR      	# Load the fresh result
    	lw a0, 0(x10)               	# a0 = Latest Potentiometer Position motor position

check_Iadc_ready:
    	la x12, R32_ADC_STATR       	# Load ADC Status Register
    	lw x11, 0(x12)
    	andi x11, x11, (1 << 2)     	# Bit 1 is JEOC (End of inject Conversion is last to finish)
    	beqz x11, check_Iadc_ready   	# If NOT ready, wait (should be instant)
#clear flags
	li   x7, ~( (1<<1)|(1<<2) ) 	# clear EOC + JEOC
	and x11,x11,x7
    	sw   x11, 0(x12)
	la   a1, R32_ADC_IDATAR1
    	lw   a1, 0(a1)             	# PA1 (injected #1) result → a1
	la   t0,input_count
	sw   a1,0(t0)			# manual potentiometer count in input_count
	
	call calc_pid		    	# a0 now contains the "Muscle Power" (-1000 to 1000), a1 has the target count


# 3. Handle Direction and PWM
    	bgez a0, set_cw             	# If positive, spin Clockwise
    
set_ccw:
    	neg a0, a0                  	# Make power positive for PWM register
	la t0,R16_TIM1_CCER
	lw x11,0(t0)			# CC1NP & CC1NE.Compare capture channel 1 complementary output polaity setting bit & enable bit
	andi x11,x11,~(1<<0)		# clear CC1P & CC1E
	li x7,(3<<2)			# active part is negative,complimentary,off part is controlled
	or x11,x11,x7			# 40% high, 60% low on pd0 TIM1CH1N
	sw x11,0(t0)
    	j apply_speed

set_cw:
    	la t0,R16_TIM1_CCER
	lw x11,0(t0)			# CC1P & CC1E.Compare capture channel 1  output polaity setting bit 0 & enable bit 1
	andi x11,x11,~(3<<2)
	li x7,(1<<0)			# active part is positive ,complimentary,off part is controlled
	or x11,x11,x7			# 40% high, 60% low on pd2 TIM1CH1
	sw x11,0(t0)			# same as above


apply_speed:
    	# Cap speed at 1000 (ATRLR limit)
    	li t1, 1000
    	ble a0, t1, store_pwm
    	mv a0, t1
store_pwm:
    	la t1, R16_TIM1_CH1CVR
    	sw a0, 0(t1)                	# Update Motor Speed

# clear interrupt flag
	la x10,R16_TIM1_INTFR
	lw x11,0(x10)
	li x7,~1			# 0<<UIF
	and x11,x11,x7
	sw x11,0(x10)


############
	lw x1,0(sp)
	lw x2,4(sp)
	lw x3,8(sp)
	lw x4,12(sp)
	lw x5,16(sp)
	lw x6,20(sp)
	lw x7,24(sp)
	lw x8,28(sp)
	lw x9,32(sp)
	lw x10,36(sp)
	lw x11,40(sp)
	lw x12,44(sp)
	lw x13,48(sp)
	lw x14,52(sp)
	lw x15,56(sp)
	addi sp,sp,60
	mret
##########################################################################################################
##########################################################

#######################################################################################
#LCD ROUTINES -------------for writing commands and data  ,use x15 to supply argument
#######################################################################################
COMMAND_WRITE:
		addi sp,sp,-8
		sw ra,0(sp)
		sw a0,4(sp)
                la a0,scratch
		sb x15,0(a0)
		andi x15,x15,0xf0
		ori x15,x15,inst_command2
		call I2C_WRITE
		call delay10us
		call delay10us
		andi x15,x15,inst_command3
		call I2C_WRITE
		call delay10us
		call delay10us
                la a0,scratch
		lb x15,0(a0)
		andi x15,x15,0x0f
		slli x15,x15,4
		ori x15,x15,inst_command2
		call I2C_WRITE
		call delay10us
		call delay10us
		andi x15,x15,inst_command3
		call I2C_WRITE
		call delay10us
		call delay10us	
		lw a0,4(sp)
		lw ra,0(sp)
		addi sp,sp,8	
		ret


DATA_WRITE:
		addi sp,sp,-8
		sw ra,0(sp)
		sw a0,4(sp)
                la a0,scratch
		sw x15,0(a0)
		andi x15,x15,0xf0
		ori x15,x15,data_command2
		call I2C_WRITE
		call delay10us
		call delay10us
		andi x15,x15,data_command3
		call I2C_WRITE
		call delay10us
		call delay10us
                la a0,scratch
		lw x15,0(a0)
		andi x15,x15,0x0f
		slli x15,x15,4
		ori x15,x15,data_command2
		call I2C_WRITE
		call delay10us
		call delay10us
		andi x15,x15,data_command3
		call I2C_WRITE
		call delay10us
		call delay10us
		lw a0,4(sp)
		lw ra,0(sp)
		addi sp,sp,8	
		ret		
#################################################################################
#hitachi LCD1602 initialization subroutine 4bit mode
#################################################################################
LCD_INIT:
		addi sp,sp,-8
		sw ra,0(sp)
		sw x15,4(sp)
		call delay50ms
		li x15,0x3c
		call I2C_WRITE
		call delay10us
		call delay10us
		li x15,0x38
		call I2C_WRITE
		call delay10ms					

		li x15,0x3c
		call I2C_WRITE
		call delay10us
		call delay10us
		li x15,0x38
		call I2C_WRITE
		call delay10ms	

		li x15,0x3c
		call I2C_WRITE
		call delay10us
		call delay10us
		li x15,0x38
		call I2C_WRITE
		call delay10ms	

		li x15,0x2c
		call I2C_WRITE
		call delay10us
		call delay10us
		li x15,0x28
		call I2C_WRITE
		call delay1ms	

		li x15,0x28
		call COMMAND_WRITE
		call delay1ms
		
	
		li x15,0x0c
		call COMMAND_WRITE
		call delay1ms
		
		li x15,0x06
		call COMMAND_WRITE
		call delay1ms
				

		li x15,0x01
		call COMMAND_WRITE
		call delay1ms
		call delay1ms
		
		li x15,0x02
		call COMMAND_WRITE
		call delay1ms
		call delay1ms

		lw x15,4(sp)
		lw ra,0(sp)
		addi sp,sp,8
		ret
#################################################################################################
#subroutine for LCD cursor positioning , part of MACRO pos . call macro pos 0,0-16 or pos 1,0-16
#################################################################################################

posi:
		addi sp,sp,-4			# adjust stack pointer
		sw ra,0(sp)			# push RA
		beqz x6,line1			# check the first parameter of macro is 0 or a higher number,if zero go to label first line
		li x6,0xc0			# if not zero the input is for 2nd line. load 0xC0 in r16 which is address of 2nd line first position DDRAM
		add x6,x6,x7			# add with horizontal postion on 2nd line to get the correct DDRAM address
		mv x15,x6			# copy new LCD DDRAM address to I2C data supply register x15
		call COMMAND_WRITE		# send via I2C
		call delay10us
		call delay10us
		call delay10us
		call delay10us
		call delay10us
		lw ra,0(sp)			# pop RA
		addi sp,sp,4			# adjust stack pointer
		ret				# return to caller
line1:
		li x6,0x80			# if Y = 0 which means 1st line of LCD load address of 1st line 1st position DDRAM =0x80
		add x6,x6,x7			# add 0x80 to X position saved in r6 to get the start postion on 1st line
		mv x15,x6			# copy new LCD DDRAM address to X15 , argument for I2C in x15
		call COMMAND_WRITE		# send via I2C
		call delay10us
		call delay10us
		call delay10us
		call delay10us
		call delay10us
		lw ra,0(sp)			# pop RA
		addi sp,sp,4			# adjust stack pointer
		ret				# return to caller		

#################################################################################
#subroutine for sending strings to LCD part of MACRO  string
# reads a string with address loaded in a2,    la a2, my_string , uses x15 for I2C
####################################################################################
string_reader:
	addi sp,sp,-8
	sw ra,0(sp)
	sw x15,4(sp)
sr_loop:
    	lb a5, 0(a2)             	# Load the current byte (character) into a1
    	beq a5, zero, end_loop   	# If character is null (0), exit the loop
	call DATA_WRITE			# send via I2C
	call delay10us
	call delay10us
	call delay10us
	call delay10us
	addi a2,a2,1			# advance message address byte by byte
	j sr_loop             		# Repeat the loop
end_loop:
	lw x15,4(sp)
	lw ra,0(sp)
	addi sp,sp,8
    	ret				# Exit the program
#################################################################################
#subroutine to clear LCD screen 
######################################################################################
cleardisplay:
		addi sp,sp,-8
		sw ra,0(sp)
		sw x15,4(sp)
		li x15,0x01
		call COMMAND_WRITE
		call delay1ms
		call delay1ms
		lw x15,4(sp)
		lw ra,0(sp)
		addi sp,sp,8
		ret




######################################################

#################################################################################
#subroutine to read ASCI values from SRAM address "mem" to LCD
#################################################################################

displayresult2:        
		addi sp,sp,-16
		sw ra,0(sp)
		sw x6,4(sp)
		sw a0,8(sp)
		sw x15,12(sp)
		pos 0,0			# cursor at 0,0
		li x6,10		# counter loaded with number of bytes, 6bytes for -xxx.x
		la a0,mem		# load ddress of mem where bytes are stored

writeloop2:
		lb x15,0(a0)		# load 1 bytes from msb >>> lsb
		call DATA_WRITE
		call delay10us
		call delay10us
		
		addi a0,a0,1
		addi x6,x6,-1
		bnez x6,writeloop2

		lw x15,12(sp)
		lw a0,8(sp)
		lw x6,4(sp)
		lw ra,0(sp)
		addi sp,sp,16
		ret   

######################################################################################


####----I2C--FUNCTIONS-----------------------------------------------------------------------------
I2C_BUSY:
	addi sp,sp,-12
	sw ra,0(sp)
	sw x10,4(sp)
	sw x11,8(sp)
IB:
	la x10, R16_I2C_STAR2 		# set pointer x10 to I2C status register 2, busy bit resides there
	lh x11,0(x10) 			# copy to x11 I2C_STAR2 register contents
	andi x11,x11,(1<<1) 		# and x11 with 1<<I2CBUSY
	bnez x11,IB 			# if not 0 loop till I2CBUSY bit becomes 0

	lw x11,8(sp)
	lw x10,4(sp)
	lw ra,0(sp)
	addi sp,sp,12
	ret 
#####################

I2C_START: 				# send start condition on I2C bus
	addi sp,sp,-20
	sw ra,0(sp)
	sw x12,4(sp)
	sw x11,8(sp)
	sw x10,12(sp)
	sw x7,16(sp)

	la x10,R16_I2C_CTLR1 		# start bit is in i2c cotrol register bit 8
	lh x11,0(x10) 			# copy contents of control register
	ori x11,x11,((1<<10) | (1<<8)) 	# set start bit8 and ack enable bit10
	sh x11,0(x10) 			# store in I2C_CTL0 register
check_master_mode_bit: 			# below code checks start bit is set , master mode bit is set and bus busy bit is set, reading STAR1 & STAR2 clears start bit
	la x10, R16_I2C_STAR1 		# set pointer to status register1
	lh x11,0(x10) 			# read contents to x11
	la x10, R16_I2C_STAR2 		# set pointer to status register2
	lh x12,0(x10) 			# read contents to x12
	slli x12,x12,16 		# shift x12 16 position to add x11 and x12 to accomodate all status bits in 1 register (x11)
	or x11,x11,x12 			# OR both registers , both STAR1 & STAR2 in X11
	li x7,0x00030001 		# BUSY, MSL and SB status bits
	and x11,x11,x7 			# ANDing yeilds the above 3 status bits
	bne x11,x7,check_master_mode_bit # if all 3 bits not sets wait in a loop

	lw x7,16(sp)
	lw x10,12(sp)
	lw x11,8(sp)
	lw x12,4(sp)
	lw ra,0(sp)
	addi sp,sp,20
	ret
#####################################

I2C_WRITE:
	addi sp,sp,-12
	sw ra,0(sp)
	sw x10,4(sp)
	sw x11,8(sp)
IW:
	la x10,R16_I2C_STAR1 		# i2c_status1 register
	lh x11,0(x10) 			# read and copy contents
	andi x11,x11,(1<<7) 		# and contents of x11 with TxE bit7 , if set transmission buffer empty
	beqz x11,IW 			# wait till TBE is set (loop if a3 is 0)
	la x10,R16_I2C_DATAR 		# set pointer to I2C data register
	sb x15,0(x10) 			# store data loaded in x15 to I2C data register

	lw x11,8(sp)
	lw x10,4(sp)
	lw ra,0(sp)
	addi sp,sp,12
	ret # return to caller
####################################

CLEAR_ACK: 				# subroutine to clear ACKEN bit in I2C_CTLR1 register
	addi sp,sp,-12
	sw ra,0(sp)
	sw x10,4(sp)
	sw x11,8(sp)

	la x10,R16_I2C_CTLR1
	lh x11,0(x10) 			# copy to x11 contents of I2C_CTL0 rgister
	andi x11,x11,~(1<<10) 		# and with 0 shifted to ACK bit10
	sh x11,0(x10) 			# write back to register

	lw x11,8(sp)
	lw x10,4(sp)
	lw ra,0(sp)
	addi sp,sp,12
	ret 				# return to caller
####################################

I2C_TX_COMPLETE: 			# subroutine checks weather I2C transmission is complete
	addi sp,sp,-12
	sw ra,0(sp)
	sw x10,4(sp)
	sw x11,8(sp)
TX:
	la x10,R16_I2C_STAR1
	lh x11,0(x10)
	andi x11,x11,(1<<7) 		# check TBE(7) is set 
	beqz x11,TX 			# if not wait by looping to label I2C_TX_COMPLETE 

	lw x11,8(sp)
	lw x10,4(sp)
	lw ra,0(sp)
	addi sp,sp,12
	ret 				# return to caller
#####################################

I2C_STOP: 				# subroutine to stop I2C transmission
	addi sp,sp,-12
	sw ra,0(sp)
	sw x10,4(sp)
	sw x11,8(sp)

	la x10,R16_I2C_CTLR1
	lh x11,0(x10)
	ori x11,x11,(1<<9) 		# set STOP bit9 in I2C_CTRL1 register
	sh x11,0(x10)

	lw x11,8(sp)
	lw x10,4(sp)
	lw ra,0(sp)
	addi sp,sp,12
	ret # return to caller
#####################################

SEND_ADDRESS: # sends address , address to be loaded in x15
	addi sp,sp,-20
	sw ra,0(sp)
	sw x10,4(sp)
	sw x11,8(sp)
	sw x12,12(sp)
	sw x7,16(sp)

	la x10,R16_I2C_DATAR 		# set pointer to data register
	sb x15,0(x10) 			# store byte in x15 to I2C data register
address_transmit:
	la x10, R16_I2C_STAR1 		# reading STAR1 followed by STAR2 clears the address bit
	lh x11,0(x10)
	la x10, R16_I2C_STAR2 		# reading STAR1 followed by STAR2 clears the address bit
	lh x12,0(x10)
	slli x12,x12,16 		# shift STAR2 by 16 bits LHS
	or x11,x11,x12 			# STAR1 & STAR2 now in x11, top16 bits STAR2 , lower 15 bits STAR1 
	li x7,0x00070082 		# BUSY, MSL, ADDR, TXE and TRA status
	and x11,x11,x7 			# and with above bit mask to see whether these bits are set in status register
	bne x11,x7,address_transmit 	# sit in tight loop until above bits are set in both status register

	lw x7,16(sp)
	lw x12,12(sp)
	lw x11,8(sp)
	lw x10,4(sp)
	lw ra,0(sp)
	addi sp,sp,20
	ret
########################################

check_i2c_status:
	addi sp,sp,-16
	sw ra,0(sp)
	sw x10,4(sp)
	sw x11,8(sp)
	sw x12,12(sp)

	la x10, R16_I2C_STAR1 		# set pointer x10 to R16_I2C_STAR1 , status register 1
	lh x11,0(x10) 			# copy contents to x11
	la x10, R16_I2C_STAR2 		# set pointer to R16_I2C_STAR2
	lh x12,0(x10) 			# copy contents to x12
	slli x12,x12,16 		# shift x12 16 position to left and OR it with x11 to hold both register values in 1 32 bit register
	or x11,x11,x12 			# status register 1 = 0-15 bits and status register2 = 16-32 bit
	la x10,buffer 			# point x10 to SRAM buffer , address 0x20000004
	sw x11,0(x10) 			# store status data in sram for future use

	lw x12,12(sp)
	lw x11,8(sp)
	lw x10,4(sp)
	lw ra,0(sp)
	addi sp,sp,16
	ret
#################################################################
#############################################
check_btf:
	addi sp,sp,-12
	sw ra,0(sp)
	sw x10,4(sp)
	sw x11,8(sp)
BTF:
	la x10,R16_I2C_STAR1
	lw x11,0(x10)
	andi x11,x11,(1<<2)
	beqz x11,BTF

	lw x11,8(sp)
	lw x10,4(sp)
	lw ra,0(sp)
	addi sp,sp,12
	ret
################################################################################

#==========================================
delay10S: 
	addi sp,sp,-8 			# push RA
	sw ra,0(sp) 			# push RA
	sw t1,4(sp)
	li t1,20100101 			# load an arbitarary value 20000000 to t1 register 
loop10S:
	addi t1,t1,-1 			# subtract 1 from t1
	bne t1,zero,loop10S 		# if t1 not equal to 0 branch to label loop
	lw t1,4(sp)
	lw ra,0(sp) 			# POP RA
	addi sp,sp,8 			# pop RA
	ret 

delay1S: 
	addi sp,sp,-8 			# push RA
	sw ra,0(sp) 			# push RA
	sw t1,4(sp)
	li t1,2010010 			# load an arbitarary value 20000000 to t1 register 
loop1s:
	addi t1,t1,-1 			# subtract 1 from t1
	bne t1,zero,loop1s 		# if t1 not equal to 0 branch to label loop
	lw t1,4(sp)
	lw ra,0(sp) 			# POP RA
	addi sp,sp,8 			# pop RA
	ret 

delay1ms:
	addi sp,sp,-8 			# push RA
	sw ra,0(sp) 			# push RA
	sw t1,4(sp) 
	li t1,2010 			# load an arbitarary value 20000000 to t1 register 
loop1ms:
	addi t1,t1,-1 			# subtract 1 from t1
	bne t1,zero,loop1ms 		# if t1 not equal to 0 branch to label loop
	lw t1,4(sp)
	lw ra,0(sp) 			# POP RA
	addi sp,sp,8 			# pop RA 
	ret 

delay10ms:
	addi sp,sp,-8 			# push RA
	sw ra,0(sp) 			# push RA
	sw t1,4(sp) 
	li t1,20100 			# load an arbitarary value 20000000 to t1 register 
loop10ms:
	addi t1,t1,-1 			# subtract 1 from t1
	bne t1,zero,loop10ms 		# if t1 not equal to 0 branch to label loop
	lw t1,4(sp)
	lw ra,0(sp) 			# POP RA
	addi sp,sp,8 			# pop RA
	ret

delay50ms:
	addi sp,sp,-8 			# push RA
	sw ra,0(sp) 			# push RA
	sw t1,4(sp) 
	li t1,100500 			# load an arbitrary value 20000000 to t1 register 
loop50ms:
	addi t1,t1,-1 			# subtract 1 from t1
	bne t1,zero,loop50ms 		# if t1 not equal to 0 branch to label loop
	lw t1,4(sp)
	lw ra,0(sp) 			# POP RA
	addi sp,sp,8 			# pop RA
	ret 

delay10us:
	addi sp,sp,-8 			# push RA
	sw ra,0(sp) 			# push RA
	sw t1,4(sp) 
	li t1,105			# load an arbitrary value 20000000 to t1 register 
loop10us:
	addi t1,t1,-1 			# subtract 1 from t1
	bne t1,zero,loop10us 		# if t1 not equal to 0 branch to label loop
	lw t1,4(sp)
	lw ra,0(sp) 			# POP RA
	addi sp,sp,8 			# pop RA
	ret 

delayus:
	addi sp,sp,-4 			# push RA
	sw ra,0(sp) 			# push RA
loopus:
	addi t1,t1,-1 			# subtract 1 from t1
	bne t1,zero,loopus 		# if t1 not equal to 0 branch to label loop
	lw ra,0(sp) 			# POP RA
	addi sp,sp,4 			# pop RA
	ret 



#######################################################################################################
# division routine, load divisor and dividend in sram before calling, result in state register ,sram
#########################################################################################################

# a1 = nimber1 # low
# a2 = number2 # high
# a5 = workreg
# a3= low register = a2:a1
# a4 =hi register = a4:a3
# t1 carry

division:
	addi sp,sp,-24
	sw a1,20(sp)
	sw a2,16(sp)
	sw a3,12(sp)
	sw a4,8(sp)
	sw a5,4(sp)
	sw t1,0(sp)
	li t1,0				# initialize t1 to 0
	li t2,0				# initialize t2 to 0
	li a2,0				# initialize a2 to 0
	li a4,0				# initialize a4 to 0
	li a5,0				# initialize a5 to 0 
	la x10,dividend			# numerator loaded here
	lw a1,0(x10)			# divident x11
	la x10,divisor			# divisor in result1,x10 points to sram result1
	lw a3,0(x10)			# load word in state to x13(divisor)
X:
	sub a5,a1,a3			# subtract divisor from dividend and store remainder in a5
	sltu t1,a1,a3			# set t1 if a1 is less than a3
	bnez t1,carry			# if t1 not equal 0 branch to carry
	mv a1,a5			# move remainder to a1 from a5
	sub a5,a2,a4			# subtract the high registers a4 from a2
	addi t2,t2,1			# increase t2 by 1 for each successful subtraction (result)
	J X				# loop to X till t1 is set
carry:
	la t0, state			# load address of state in t0
	sw t2,0(t0)			# store result in t2 in state
#	la t0, result2			# load address of result2 in t0
#	sw a1,0(t0)			# store a1 high byte of result in result2 = 0
	lw t1,0(sp)
	lw a5,4(sp)
	lw a4,8(sp)
	lw a3,12(sp)
	lw a2,16(sp)
	lw a1,20(sp)
	addi sp,sp,24
	ret

##############################################################################################
#######################################################################################
# ────────────────────────────────────────────────────────────────
# signed version deimal to ASCII converter for 1602 LCD , "call convert_to_decimal_signed"
# Input:  value in result_lo (treated as unsigned)
# Output: ASCII digits stored backwards in mem (as before)
# ────────────────────────────────────────────────────────────────
convert_to_decimal_unsigned:
    addi sp, sp, -24
    sw ra,  0(sp)
    sw a0,  4(sp)
    sw gp,  8(sp)
    sw tp, 12(sp)
    sw t2, 16(sp)
    sw t0, 20(sp)

    la a0, result_lo
    lw a0, 0(a0)                # load unsigned value

    la gp, mem                  # result buffer
lb t0,0(gp)

li tp, 0x20202000           	# spaces   li tp, 0x20202020
or tp,tp,t0
    sw tp, 0(gp)
li tp, 0x20202020
    sw tp, 4(gp)
    sw tp, 8(gp)
    addi gp, gp, 9              # start from end (backwards)

digit_loop_u:
    call div_u10                # a0 = quot, tp = rem (0-9)
    addi tp, tp, '0'
    sb tp, 0(gp)
    addi gp, gp, -1
    addi t2, t2, 1
    bnez a0, digit_loop_u

    # Restore
    lw t0, 20(sp)
    lw t2, 16(sp)
    lw tp, 12(sp)
    lw gp,  8(sp)
    lw a0,  4(sp)
    lw ra,  0(sp)
    addi sp, sp, 24
    ret


# ────────────────────────────────────────────────────────────────
# Signed version – handles negative numbers
# Input:  value in result_lo (signed 32-bit)
# Output: ASCII digits in mem (with '-' if negative)
#         Calls the unsigned version internally after handling sign
# ────────────────────────────────────────────────────────────────
convert_to_decimal_signed:
    addi sp, sp, -24
    sw ra,  0(sp)
    sw a0,  4(sp)
    sw gp,  8(sp)
    sw tp, 12(sp)
    sw t2, 16(sp)
    sw s0, 20(sp)               # extra for sign handling

    la a0, result_lo
    lw s0, 0(a0)                # s0 = signed value

    bgez s0, no_sign            # positive or zero → no '-'

    # Negative number: store '-' and take absolute value
    li   a0, '-'
    la   gp, mem
    sb   a0, 0(gp)              # put '-' at beginning
    #addi gp, gp, 1              # move pointer after '-'
    neg  s0, s0                 # s0 = |value|

    # Store |value| back to result_lo so unsigned version can use it
    la   a0, result_lo
    sw   s0, 0(a0)
    j process
no_sign:
    li   a0, 0x20
    la   gp, mem
    sb   a0, 0(gp)
process:
    # Now call the unsigned converter (it will fill from mem+1 or mem)
    call convert_to_decimal_unsigned

    # If we had negative, we already put '-' at mem+0
    # Unsigned version wrote digits starting from mem+9 backwards
    # → result is correct ( '-' + digits or just digits )

    lw s0, 20(sp)
    lw t2, 16(sp)
    lw tp, 12(sp)
    lw gp,  8(sp)
    lw a0,  4(sp)
    lw ra,  0(sp)
    addi sp, sp, 24
    ret


# Your existing div_u10 remains unchanged (it's already good)
div_u10:
    addi sp,sp,-20
    sw ra,0(sp)
    sw a1,4(sp)
    sw t0,8(sp)
    sw gp,12(sp)
    sw t2,16(sp)
    li    a1, 0           # Clear remainder
    li    t0, 32          # 32 bits
    mv    gp, a0          # working copy
    li    a0, 0           # quotient
div_loop:
    slli  a0, a0, 1
    srli  t2, gp, 31
    slli  gp, gp, 1
    slli  a1, a1, 1
    or    a1, a1, t2
    li    t2, 10
    bltu  a1, t2, skip_sub
    sub   a1, a1, t2
    ori   a0, a0, 1
skip_sub:
    addi  t0, t0, -1
    bnez  t0, div_loop
    mv    tp,a1           # remainder to tp
    lw t2,16(sp)
    lw gp,12(sp)
    lw t0,8(sp)
    lw a1,4(sp)
    lw ra,0(sp)
    addi sp,sp,20
    ret
######################################################################################
ddivision:
# Register Usage:
# a0 = input number / quotient
# a1 = remainder
# t0 = bit counter (32)
# t1 = scratch
#eg	li a0,0xffffffff
#eg	call div_u10
#eg       ret

# Input: a0 = number to divide (e.g., 100)
# Output: a0 = quotient (e.g., 10), a1 = remainder (e.g., 0)
ddiv_u10:
    li    a1, 0           # Clear remainder
    li    t0, 32          # 32 bits to process
    mv    t1, a0          # t1 = working copy of input
    li    a0, 0           # a0 will store quotient

ddiv_loop:
    # Build quotient in a0
    slli  a0, a0, 1       # Shift quotient left
    
    # Process next bit
    slli  t1, t1, 1       # Shift input left
    srli  t2, t1, 31      # Get MSB
    slli  a1, a1, 1       # Shift remainder left
    or    a1, a1, t2      # Insert new bit
    
    # Check if remainder >= 10
    li    t2, 10
    bltu  a1, t2, skip_sub
    
    # Adjust remainder and set quotient bit
    sub   a1, a1, t2
    ori   a0, a0, 1       # Set LSB of quotient
    
sskip_sub:
    addi  t0, t0, -1
    bnez  t0, div_loop
    
    ret        # Result: a0=quotient, a1=remainder
###################################################################################




calc_pid:
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s1, 4(sp)
    sw s0, 8(sp)
    sw gp, 12(sp)
    sw t0, 16(sp)
    sw t1, 20(sp)
    sw tp, 24(sp)
    sw t2, 28(sp)
    sub t0, a1, a0              # t0 = error = target - current (integer)

    # --- P TERM ---
    la t1, kp_gain
    lw a1, 0(t1)                # a1 = Kp (Q16.16)
    mv a0, t0                   # a0 = error
    call signed_multiply_booth

    # Get scaled P (>>16 from low word — good enough for |error| < 2048)
    la t1, result_lo
    lw t1, 0(t1)
    srai s1, t1, 16             # s1 = P term (integer-ish)


    # --- I TERM ---
    la t1, i_accum
    lw t2, 0(t1)
    add t2, t2, t0              # accum += error

    # Anti-windup (adjust limit to your needs, e.g. ±500–1000)
    li t1, 500
    ble t2, t1, i_low
    mv t2, t1
i_low:
    li t1, -500
    bge t2, t1, i_store
    mv t2, t1
i_store:
    la t1, i_accum
    sw t2, 0(t1)

    la t1, ki_gain
    lw a1, 0(t1)
    mv a0, t2
    call signed_multiply_booth

    la t1, result_lo
    lw t1, 0(t1)
    srai s0, t1, 16             # s0 = I term

    # --- D TERM ---
    la t1, last_error
    lw t2, 0(t1)
    sub tp, t0, t2              # delta = current_error - last_error
    sw t0, 0(t1)                # update last_error

    la t1, kd_gain
    lw a1, 0(t1)
    mv a0, tp
    call signed_multiply_booth

    la t1, result_lo
    lw t1, 0(t1)
    srai gp, t1, 12             # D usually keeps more bits (>>12 example)

    # --- Combine ---
    add a0, s1, s0              # P + I
    add a0, a0, gp              # + D

    # Saturate PWM to -1000 .. +1000 (critical!)
    li t1, 1000
    li t2, -1000
    bge a0, t2, no_min
    mv a0, t2
    j pid_done
no_min:
    ble a0, t1, pid_done
    mv a0, t1
pid_done:
    lw t2, 28(sp)
    lw tp, 24(sp)
    lw t1, 20(sp)
    lw t0, 16(sp)
    lw gp, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 32
    ret

############################################################################################################
# signed multiplication, call with arguments in buffer & buffer1. answer in result_hi,result_lo
############################################################################################################

signed_multiply_booth:
    addi sp, sp, -36
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw a2, 12(sp) 
    sw a3, 16(sp) 
    sw a4, 20(sp)
    sw a5, 24(sp)
    sw t0, 28(sp)
    sw t1,32(sp)

    # Load operands
    
    mv s0, a0       # multiplicand M (signed) s0
    
    mv s1, a1       # multiplier Q (signed) s1

    # Initialize
    li a2, 0           # A (accumulator, hi)
    mv a3, s1          # Q (lo)
    li a4, 0           # Q-1 (extra bit)
    li a5, 32          # counter

booth_loop:
    # Get bits Q0 and Q-1
    andi t0, a3, 1     # Q0
    mv t1, t0          # temp Q0
    slli t0, t0, 1     # Q0 << 1
    or t0, t0, a4      # bits = Q0:Q-1

    # Decide action
    li t2, 1           # 01: add M
    beq t0, t2, add_m
    li t2, 2           # 10: sub M
    beq t0, t2, sub_m
    j shift            # 00 or 11: no op

add_m:
    add a2, a2, s0
    j shift

sub_m:
    sub a2, a2, s0
    j shift

shift:
    # Update Q-1 for next = old Q0
    mv a4, t1

    # Arithmetic right shift of A:Q (64-bit signed)
    andi t0, a2, 1     # A LSB for Q MSB
    srai a2, a2, 1     # A >>= 1 (arithmetic, preserves sign)
    slli t0, t0, 31    # to MSB pos
    srli a3, a3, 1     # Q >>= 1
    or a3, a3, t0      # insert old A LSB into Q MSB

    addi a5, a5, -1
    bnez a5, booth_loop

    # Store results (s2: hi, s3: lo)
    la a0, result_hi
    sw a2, 0(a0)
    la a0, result_lo
    sw a3, 0(a0)

    # Restore registers
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw a2, 12(sp)
    lw a3, 16(sp)
    lw a4, 20(sp)
    lw a5, 24(sp)
    lw t0,28(sp)
    lw t1,32(sp)
    addi sp, sp, 36
    ret
##################################################################################
.align 4
.section .rodata
.global message

message1: .asciz "hello "
message2: .asciz "hi"
message3: .asciz "0"
message7: .asciz "1"	
name: .asciz "SAJEEV SANKARAN CH32V003 UART"





