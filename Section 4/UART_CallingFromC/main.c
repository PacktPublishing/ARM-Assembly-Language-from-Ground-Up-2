#include <stdio.h>

extern char UART_WriteChar(char ch);
extern void UART_Init(void);
extern char UART_ReadChar();
void test_setup(void);


int main()
{
	UART_Init();
	// test_setup();

	 printf("Hello World");
	while(1){
		//UART_WriteChar('h');
		
	
	}
	
}

struct __FILE{int handle;};
FILE __stdin =  {0};
FILE __stdout = {1};
FILE __stderr	= {2};
	

int fgetc(FILE *f){
	int c;
	c = UART_ReadChar();
	
	if(c == '\r'){
	  UART_WriteChar(c);
		c ='\n';
	}
	
	UART_WriteChar(c);
	
	return c;
	
}


int fputc(int c, FILE *f){
   
	return UART_WriteChar(c);
}


int n;
char str[80];

void test_setup(void){
	
  printf("Please enter a number : ");
	scanf("%d",&n);
	printf("The number entered is :  %d \r\n",n);
	
	printf("Please type a character string :");
	gets(str);
	printf("The character string entered is : ");
	puts(str);
	printf("\r\n");
 
}

