/*
 * led_display.c
 *
 * Created: 12/18/2022 12:23:43 AM
 * Author : ASUS
 */ 
#define F_CPU 1000000  ///defining cpu frequency to calculate delays 
#include <avr/io.h>
#include <util/delay.h>

/// polarity cathode means 

/// we are gonna assume that, to make a row active, we need to keep corresponding row value 0
/// this array would make sure one row is active at a time
char rowActive[]={
	0b11111110,0b11111101,0b11111011,0b11110111,0b11101111,0b11011111,0b10111111,0b01111111
};
// we are gonna assume that, to make a col active, we need to keep corresponding col value 1
// this array would be multidimensional array
// if we want to print one stable pattern, this 2D array would have just one row.....
char colActive[][8]={
	
	//{0x00,0x18,0x24,0x42,0x42,0x7e,0x42,0x42},  ///print A
	//{0x00,0x7c,0x42,0x42,0x42,0x42,0x42,0x7c},  ///print D
	//{0x08,0x18,0x28,0x48,0x08,0x08,0x7e,0x00},//W
	{0x1c,0x22,0x40,0x40,0x40,0x40,0x22,0x1c}//C
	//{0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}
};

char rotLeft(char col)  /// for rotation of bits to simulate sliding....
{
	char musk = (1 << 7);
	if ((musk & (col)) != 0)
	{
		col = col << 1;

		++col;
	}
	else
	{
		col = col << 1;
	}
	return col;
}

void slide()
{
	/* Replace with your application code */
	//use DDRX to declare input or output, setting a bit 1 means it is output or vice versa
	DDRB=0xFF;
	DDRA=0xFF;
	while (1)
	{
		for(int i=0;i<8;i++) /// one bit rotation at a time
		{
			int u=100; /// one bit slide after every 800ms
			
			while(u>0) /// this loop to ensure continuous print of same pattern for 800 ms 
			{
				u--;
				for(int j=0;j<8;j++) 
				{
					/// our display was anode, so we needed to not the bits...
					
					PORTB=~rowActive[j];
					PORTA=~colActive[0][j];  
					
					_delay_ms(1); /// we can't see....
					
				}
				
			}
			/// time to shift!!!
			for(int k=0;k<8;k++)
			colActive[0][k]=rotLeft(colActive[0][k]);
			
			
			
		}
		
	}
}

void static_()
{
	
	    /* Replace with your application code */
	    //use DDRX to declare input or output, setting a bit 1 means it is output or vice versa
	    DDRB=0xFF;
	    DDRA=0xFF;
	    while (1)
	    {
		     
			    
				    for(int j=0;j<8;j++) /// need to light up 8 row and columns 
				    {
					   /// anode..so, not the bits......(why? study the lab sheet!!!!)
					    PORTB=~rowActive[j];
					    PORTA=~colActive[0][j];  
					    
					    _delay_ms(1); /// we can't see....
					    
				    }
				    
			   
	    }
}


int main(void)
{
	//static_();
	slide();
}

