

#include "StdTypes.h"
#include "Utlis.h"
#include "MemMap.h"

#define F_CPU 8000000
#include <util/delay.h>

#include "DIO_Interface.h"
#include "DIO_Private.h"
#include "ADC_Interface.h"
#include "UART.h"
#include "UART_Service.h"

#include "LCD_Interface.h"


// u16 read_axis(int axis)
// {
// 	u32 reading = 0;
// 	for(int i = 0;i<10;i++)
// 	{
// 		reading += ADC_Read(axis);
// 	}
// 	return reading/10;
// }

int main(void)
{
	//**************************Init*****************************//
	DIO_Init();
	ADC_Init(VREF_VCC,ADC_SCALER_64);
	LCD_Init();
	UART_Init();
	LCD_SetCursor(0,0);
	LCD_WriteString("Earthquake Dete.");
	DIO_WritePort(PB,0);
	//***********************************************************//
	u16 x_axis_S = 0;
	u16 y_axis_S = 0;
	u16 x_axis_R = 0;
	u16 y_axis_R = 0;
	char state = 0;
	char check = 0;
	//************************ Setup AVR & Matlab ****************//

	UART_Send('c');
	while(state != 'v')
	{
	state = UART_Receive();
		if(state = 'v')
		{
			LCD_SetCursor(1,0);
			LCD_WriteString("Connection Success...");
			_delay_ms(2000);
			LCD_SetCursor(1,0);
			LCD_WriteString("                                 ");
		}
	}
	
	//************************************************************//
    while (1) 
    {
// 		LCD_SetCursor(1,0);
// 		x_axis = read_axis(CH_7);
// 		LCD_SetCursor(1,0);
// 		LCD_WriteNumber(x_axis);
// 		y_axis = read_axis(CH_0);
// 		LCD_SetCursor(1,6);
// 		LCD_WriteNumber(y_axis);
// 	LCD_SetCursor(1,0);
// 	LCD_WriteString("                 ");
		
		check = UART_ReceivePeriodic(&state);
		if(check == 1)
		{
			if(state == 'S')
			{
				x_axis_S = ADC_Read(CH_7);
				UART_SendNumber16(x_axis_S);
				y_axis_S = ADC_Read(CH_0);
				UART_SendNumber16(y_axis_S);
			}
			if(state == 'E')
			{
				state  = 'R';
				Dio_WritePin(PINC5,HIGH);
				LCD_SetCursor(1,0);
				LCD_WriteString("State:Earthquake!");
				DIO_WritePort(PB,255);
				_delay_ms(1000);
				Dio_WritePin(PINC5,LOW);
				DIO_WritePort(PB,0);
				LCD_SetCursor(1,0);
				LCD_WriteString("                  ");
			}
		}
LCD_SetCursor(1,0);
LCD_WriteString("State : Normal     ");
	}
	
}

