#riscv32-unknown-elf-as -g servo2_1.S -o servo2_1.O
#riscv32-unknown-elf-ld -T CH32V003.ld -Map=final.map servo2_1.O
#riscv32-unknown-elf-objcopy -O ihex a.out servo2_1.hex
# new linker version
#.\riscv32-unknown-elf-as -g servo2_1.S -o servo2_1.O
#.\riscv32-unknown-elf-ld -T CH32V003.ld --Map final.map servo2_1.O
#.\riscv32-unknown-elf-objcopy -O ihex a.out servo2_1.hex


# works fine on testing, PWM mode 1 , PD2 outputs the waveform of 1khz,1ms-0ms, 
#R16_TIM2_CH2CVR decides pulse width , 0-1000 steps
# CCER register polarity if 1 low prt is controlled if polarity is 0 high part is controlled
# timer 1 has 4 channels , each chanel from 1-3 has normal and complementary outputs that are tied to different pins
# clock is prescaled to timer clock with PSC divider, auto reload register decides frequency, interrupt is decided by overflow.
# number of intrrupts is counted to get isr based deceisions else isr resets interrupt flags
#52.1 = 9600
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
#l Rule group: consists of up to 16 conversions. The rule channels and their conversion order are set in the
#ADC_RSQRx register. The total number of conversions in the rule group should be written to RLEN[3:0]
#in the ADC_RSQR1 register.
#l Injection group: consists of up to 4 conversions. The injection channels and the order of their conversions
#are set in the ADC_ISQR register. The total number of conversions in the injection group should be
#written in ILEN[1:0] of the ADC_ISQR register.
#Initialize the calibration register by writing RSTCAL position 1 of ADC_CTLR2 register and wait for
#RSTCALhardware to clear 0 to indicate the completion of initialization



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
.equ sign,  0x2000000C
.equ adc_1616,  0x20000010
.equ pwm_1616,  0x20000014
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
.equ PID, 0x20000044
.equ state,  0x20000048
.equ prev_error, 0x2000004C
.equ integral,0x20000058
.equ current_error,0x2000005C
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
	ori x11,x11,(1<<0)		# timer2 clock enable
	sw x11,0(x10)
#Enable ADC prescaler in clock configuration register
	la x10,R32_RCC_CFGR0
	lw x11,0(x10)
	li x7,(8<<11)			# 0b01000 ADC prescalar ahb/4 = 8/4 = 2mhz
	or x11,x11,x7
	sw x11,0(x10)

 

#configure GPIOD 
	li x10,R32_GPIOD_CFGLR				# load pointer x10 with address of R32_GPIOD_CFGLR , GPIO configuration register
	lw x11,0(x10)					# load contents from register pointed by x10
	li x7,~((0xf<<0)|(0xf<<8)|(0xf<<16))		# clear pd0,pd2 we need to setup for pwm on CH1 & CH1N , pd4 for AIN7
	and x11,x11,x7					# clear pd3,pd4 mode and cnf bits for selected pin D3
	li x7,((0xB<<0)|(0xB<<8)|(0x3<<16))		# pd0,pd4 =  multiplex pushpull for ch1 pwm capture compare output,pd4 pushpull
	or x11,x11,x7					# OR value to register
	sw x11,0(x10)					# store in R32_GPIOD_CFGLR

#configure GPIOC 
	li x10,R32_GPIOC_CFGLR				# load pointer x10 with address of R32_GPIOD_CFGLR , GPIO configuration register
	lw x11,0(x10)					# load contents from register pointed by x10
	li x7,~(0xf<<16)				# clear pc4
	and x11,x11,x7					# clear pc4  pc4 =  analog input for adc
	sw x11,0(x10)					# store in R32_GPIOC_CFGLR

#disable ADC before configuration
	la x10,R32_ADC_CTLR2
	lw x11,0(x10)
	li x7,0xfffffffe				#disable ADON bit , 0 written in 0bit
	and x11,x11,x7
	sw x11,0(x10)

# --- Link Timer 1 CH2 to ADC Trigger ---
	la x10, R32_ADC_CTLR2
	lw x11, 0(x10)
# 1. Select Trigger Source (EXTSEL bits 19:17)# For CH32V003: 010 = Timer 1 event Channel 2 
	li x7, (2 << 17)  				# 010<<17      
	or x11, x11, x7
# 2. Enable External Trigger (EXTTRIG bit 20)
	li x7, (1 << 20)
	or x11, x11, x7
	sw x11, 0(x10)

#set sequence of conversion channel
	la x10,R32_ADC_RSQR3				# sequence register, if multiple sensors used we can determine the order of conversion
	lw x11,0(x10)
	li x7,(2<<0)					# AIN2 , PC4 adc channel is written to sequence 1 (only one channel in this project)	
	or x11,x11,x7
	sw x11,0(x10)

#set sampling cycles
	la x10,R32_ADC_SAMPTR2				# takes sampling cycles for each measurement
	lw x11,0(x10)
	li x7,(7<<21)					# 0b111/0x7 is 241 cycles	
	or x11,x11,x7
	sw x11,0(x10)

#enable adc in control register2
	la x10,R32_ADC_CTLR2
	lw x11,0(x10)
	li x7,((7<<17)|(1<<0))				# SWSTART trigger for ADC and ADON
	or x11,x11,x7
	sw x11,0(x10)

#reset calibrate ADC
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

######################################
#####################################################################

	li a0,buffer
	sw zero,0(a0)
	

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
	li x11,0			# start with 0 pwm,  each count is = 0.1% duty cycle
	sw x11,0(x10)
	la x10,R16_TIM1_CHCTLR1
	lw x11,0(x10)
	li x7,(6<<4)|(1<<3)		# CH1 mode-1(0b110=6), CH1 output compare preload enable OC2PE to reduce jitter,
	or x11,x11,x7
	sw x11,0(x10)


# --- Setup Channel 2 as the Trigger Phase Delay ---
	la x10, R16_TIM1_CH2CVR
	la x11, R16_TIM1_CH1CVR
	lw x11, 0(x11)             	# count for how much time motor runs
	addi x11,x11,50			# increase count by 50 so that CH2 triggers ADC after 50 counts of motor stops
	sw x11, 0(x10)
# for ADC trigger signal
	la x10, R16_TIM1_CHCTLR1
	lw x11, 0(x10)
	li x7, (7 << 12)        	# OC2M = 0b111 (PWM Mode 2) for a clean rising edge
	or x11, x11, x7
	sw x11, 0(x10)

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
	ori x7, x7, 160        		# Add 20us Dead-time (DTG bits 0-7)
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

# enabling GLOBAL INTERRUPTS
	li t0, 0x88			# load MPIE and MIE bits , 1<<MIE in mstatus is enabling GLOBAL INTERRUPTS
	csrw mstatus,t0 		# csrrw the values in t0,


######################################################


##########################################################################




itr: 	
			
	j itr

	

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
	
###########

	la x10,R16_TIM1_INTFR
	lw x11,0(x10)
	li x7,~1			# 0<<UIF
	and x11,x11,x7
	sw x11,0(x10)

check_adc_ready:
    	la x10, R32_ADC_STATR       # Load ADC Status Register
    	lw x11, 0(x10)
    	andi x11, x11, (1 << 1)     # Bit 1 is EOC (End of Conversion)
    	beqz x11, check_adc_ready   # If NOT ready, wait (should be instant)
	la x10, R32_ADC_RDATAR      # Load the fresh result
    	lw s1, 0(x10)               # s1 = Latest Potentiometer Position



	call calc_pid		    # a0 now contains the "Muscle Power" (-1000 to 1000)

# 3. Handle Direction and PWM
    	bgez a0, set_cw             # If positive, spin Clockwise
    
set_ccw:
    	neg a0, a0                  # Make power positive for PWM register
	la x10,R16_TIM1_CCER
	lw x11,0(x10)			# CC1NP & CC1NE.Compare capture channel 1 complementary output polaity setting bit & enable bit
	andi x11,x11,~(1<<0)		# clear CC1P & CC1E
	li x7,(3<<2)			# active part is negative,complimentary,off part is controlled
	or x11,x11,x7			# 40% high, 60% low on pd0 TIM1CH1N
	sw x11,0(x10)
    	j apply_speed

set_cw:
    	la x10,R16_TIM1_CCER
	lw x11,0(x10)			# CC1P & CC1E.Compare capture channel 1  output polaity setting bit 0 & enable bit 1
	andi x11,x11,~(3<<2)
	li x7,(1<<0)			# active part is positive ,complimentary,off part is controlled
	or x11,x11,x7			# 40% high, 60% low on pd2 TIM1CH1
	sw x11,0(x10)			# same as above


apply_speed:
    	# Cap speed at 1000 (ATRLR limit)
    	li t1, 1000
    	ble a0, t1, store_pwm
    	mv a0, t1
store_pwm:
    	la t1, R16_TIM1_CH1CVR
    	sw a0, 0(t1)                # Update Motor Speed


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









# --- PID CALCULATION BLOCK ---
# Input:  a0 = Current Position (from ADC)
#         a1 = Target Position
# Output: a0 = Calculated PWM Power (-1000 to 1000)

calc_pid:
	sub t0, a1, a0              # t0 = Error (Target - Current)
    
        # --- P TERM ---
    	la t1, kp_gain
    	lw t2, 0(t1)
    	mul s1, t0, t2              # s1 = P_out (Error * Kp)

    	# --- I TERM ---
    	la t1, i_accum
    	lw t2, 0(t1)
    	add t2, t2, t0              # Accumulate error
    
    	# Anti-Windup (Cap the I-term at +/- 200)
    	li t3, 200
    	ble t2, t3, i_low
    	mv t2, t3
i_low:
    	li t3, -200
    	bge t2, t3, i_store
    	mv t2, t3
i_store:
    	sw t2, 0(t1)                # Save I-accumulator
    	la t1, ki_gain
    	lw t3, 0(t1)
    	mul s2, t2, t3              # s2 = I_out (Accumulator * Ki)

    	# --- D TERM (Prevents Overshoot) ---
    	la t1, last_error
    	lw t2, 0(t1)                # Load previous error
    	sub t3, t0, t2              # t3 = Delta_Error (Current - Last)
    	sw t0, 0(t1)                # Save current error for next 1ms
    	la t1, kd_gain
    	lw t4, 0(t1)
    	mul s3, t3, t4              # s3 = D_out (Delta * Kd)

    	# --- COMBINE PID ---
    	add a0, s1, s2              # P + I
    	add a0, a0, s3              # (P + I) + D
    	ret
