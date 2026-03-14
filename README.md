# wipermotor_servo_dev_ch32v003
servo_from_scratch_with_ch32v003_on_wipermotor. developing code
motor position potentiometer on PC4
user input position on PA1
motor PWM on PD2 & PD0
I2C SDA PC1
i2C SCL PC2
# ADC is set to read PC4 for motor position as regular channel
# ADC to read input/target potentiometer is on PA1 as injected channel
# ADC is triggered by PWM signal from timer1 CH2 internally. first pc4 is converted then due to JAUTO bit injected chanel follows automatically
# ADC results stored in RDATAR & IDATAR
# motor controlled by PWM1 on CH1 & CH1N. PD2 & PD0 , value updated by timer1 ISR every 1ms

motor controlled by HW039 module, H bridge motor controller from ali express. tested and works fine ADC_GCC_ver1.S
