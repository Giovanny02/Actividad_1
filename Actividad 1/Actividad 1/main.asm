;
; Actividad 1.asm
;
; Created: 14/02/2024 12:42:03 a. m.
; Author : Uriel Huerta, Axel Vallejo, Giovani Orozco
;Programa para generar 4 diferentes se�ales con frecuencias distintas
;dependiendo de los estados de entrada

.cseg	
.org 0x00
.def temp = r16


;Main program
	;Stack init
	ldi temp,high(RAMEND) ;High byte
	out SPH,temp
	ldi temp,low(RAMEND) ;Low byte
	out SPL,temp


;Port configuration
	ldi temp,0b00100000 ; PB5->output // input->PB4 y PB3 (por posicion de 0's y 1's) 
	out DDRB,temp 
	sbi PORTB,PB4 ;activa la resistencia de pull-up en puerto 4
	sbi PORTB,PB3 ;activa la resistencia de pull-up en puerto 3 
;PORTB coloca el puerto en modo escritura
;En estos momentos ambos puertos estar�an con un 1 l�gico
	
;Inicializar el TIMER1 de 16 bits Pagina 123 datasheet
	ldi r17,0xFF ; Byte m�s alto de 0xFFFF
	ldi r16,0xFF ; Byte m�s bajo de 0xFFFF
	out TCNT1H,R17 
	out TCNT1L,R16

;Configurar el modo de operaci�n del Timer1
	ldi r17,0x00 ; Modo Normal
	out TCCR1B,R17

;Configurar el prescaler
	ldi r17,0x06 ; Prescaler de 256
	out TCCR1B,R17

;Habilitar la interrupci�n del Timer1
	ldi r17,0x01 ; Habilitar interrupci�n TOIE1
	out TIMSK1,R17

;Subrutinas
entrada_00:
	in temp,PB3
	andi temp,0b00000000 ;verifica si est� en ceros
	brne freq1 ;si est� en 00 salta a la frecuencia 1 
	cbi PORTB,PB3

entrada_11:
	in temp,PB3
	andi temp,0b00001100 ;verifica si est� en ceros
	brne freq4 ;si est� en 4 salta a la frecuencia 4 
	cbi PORTB,PB3

freq1:
	sbi PORTB,PB3
	rjmp entrada_00

freq4:
	sbi PORTB,PB3
	rjmp entrada_11

