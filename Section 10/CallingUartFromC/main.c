
extern void UART_Init(void);
;extern void newline(void);
extern char UART_ReadChar(void);
extern void UART_WriteChar(char ch);


int main(){
	
	UART_Init();
	
	
	while(1){
	UART_WriteChar('H');
//newline();

	}
	
	
}


	

