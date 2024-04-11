#define F_CPU 1000000
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h> //STEP1

void uart_init()
{
	UCSRA = 0b00000010; // U2X = 1 -> UBBR = F_CPU/(8xbaud) -1 = 12
	UCSRB = 0b00011000; // USART Transmitter and Receiver enabled
	UCSRC = 0b10000110; 
	
	// UCSZ = 011 -> 8 bit
	UBRRH = 0;
	UBRRL = 12;
}

void uart_send(unsigned char data){
	while ((UCSRA & (1<<UDRE)) == 0x00); // Wait until USART data register is empty
	UDR = data; 
}

unsigned char uart_receive(void){
	while ((UCSRA & (1<<RXC)) == 0x00);
	return UDR;
}

ISR(INT0_vect)//STEP2
{
	PORTA = ~PORTA;
	uart_send('a');
}

int main(void)
{
	DDRA = 0xFF;
	
	GICR = (1 << INT0); //STEP3
	MCUCR = MCUCR | (1 << ISC01);//STEP4
	MCUCR = MCUCR & (~(1 << ISC00));//STEP4
	sei();//STEP5
	
	uart_init();
	_delay_ms(1000);
	while(1);
}