
#include <stdint.h>
extern void GPIOA_Init(void);
extern void ADC1_Init(void);
extern uint32_t ADC1_Read(void);
extern void Led_Control(void);

uint32_t sensorVal;

int main(){
	GPIOA_Init();
	ADC1_Init();
	
   while(1){
	 sensorVal = ADC1_Read();
	 Led_Control(); 
	 }
}



