#include "main.h"
//#include <stdio.h>
#include "stdbool.h"

#define VD123_ON 123
#define VD1222_ON 1222
#define VD8_ON NT_GPIOC->MASKHIGHBYTE_bit[32].MASKHB = 0
#define VD8_OFF NT_GPIOC->MASKHIGHBYTE_bit[32].MASKHB = 32
#define VD9_ON NT_GPIOC->MASKHIGHBYTE_bit[64].MASKHB = 0
#define VD9_OFF NT_GPIOC->MASKHIGHBYTE_bit[64].MASKHB = 64
#define VD10_ON NT_GPIOC->MASKHIGHBYTE_bit[128].MASKHB = 0
#define VD10_OFF NT_GPIOC->MASKHIGHBYTE_bit[128].MASKHB = 128
#define VD11_ON NT_GPIOD->MASKHIGHBYTE_bit[32].MASKHB = 0
#define VD11_OFF NT_GPIOD->MASKHIGHBYTE_bit[32].MASKHB = 32
#define VD13_ON NT_GPIOD->MASKHIGHBYTE_bit[64].MASKHB = 0
#define VD13_OFF NT_GPIOD->MASKHIGHBYTE_bit[64].MASKHB = 64
#define VD14_ON NT_GPIOD->MASKHIGHBYTE_bit[128].MASKHB = 0
#define VD14_OFF NT_GPIOD->MASKHIGHBYTE_bit[128].MASKHB = 128
#define VD15_ON NT_GPIOE->MASKLOWBYTE_bit[4].MASKLB = 0
#define VD15_OFF NT_GPIOE->MASKLOWBYTE_bit[4].MASKLB = 4
#define VD16_ON NT_GPIOE->MASKLOWBYTE_bit[8].MASKLB = 0
#define VD16_OFF NT_GPIOE->MASKLOWBYTE_bit[8].MASKLB = 8
//Переопределение портов на выкл
#define PB15_OFF NT_GPIOB->MASKHIGHBYTE_bit[128].MASKHB = 0
#define PA12_OFF NT_GPIOA->MASKHIGHBYTE_bit[64].MASKHB = 0
#define PA14_OFF NT_GPIOA->MASKHIGHBYTE_bit[16].MASKHB = 0
//Переопределение портов на вкл
#define PB14_ON NT_GPIOB->MASKHIGHBYTE_bit[64].MASKHB = 64
#define PB13_ON NT_GPIOB->MASKHIGHBYTE_bit[32].MASKHB = 32
#define PA10_ON NT_GPIOA->MASKHIGHBYTE_bit[4].MASKHB = 4
#define PA8_ON NT_GPIOA->MASKHIGHBYTE_bit[1].MASKHB = 1
//Переопределение портов на вкл
#define PB15_ON NT_GPIOB->MASKHIGHBYTE_bit[128].MASKHB = 128
#define PA12_ON NT_GPIOA->MASKHIGHBYTE_bit[64].MASKHB = 64
#define PA14_ON NT_GPIOA->MASKHIGHBYTE_bit[16].MASKHB = 16
//Переопределение портов на выкл
#define PB14_OFF NT_GPIOB->MASKHIGHBYTE_bit[64].MASKHB = 0
#define PB13_OFF NT_GPIOB->MASKHIGHBYTE_bit[32].MASKHB = 0
#define PA10_OFF NT_GPIOA->MASKHIGHBYTE_bit[4].MASKHB = 0
#define PA8_OFF NT_GPIOA->MASKHIGHBYTE_bit[1].MASKHB = 0
// Константы
#define CONST_ADC 1638.4
//Глобальная переменная периода счета таймера (может быть изменена при остановке расчета в окне просмотра переменных)
int TimerPeriod = 500000;
//Функция инициализации дискретных выходов микроконтроллера для управления светодиодами
void LED_init (void) {
    // Переопределения ножек для работы с АЦП(на входы и выходы)
    //входы с ацп
    NT_GPIOA->ALTFUNCCLR_bit.ALTFUNCCLR = (1 << 12);
    NT_GPIOA->OUTENSET_bit.OUTENSET |= (0 << 12);
    NT_GPIOA->ALTFUNCCLR_bit.ALTFUNCCLR = (1 << 14);
    NT_GPIOA->OUTENSET_bit.OUTENSET |= (0 << 14);
    //выходы ацп
    NT_GPIOA->ALTFUNCCLR_bit.ALTFUNCCLR = (1 << 8);
    NT_GPIOA->OUTENSET_bit.OUTENSET |= (1 << 8);
    NT_GPIOA->ALTFUNCCLR_bit.ALTFUNCCLR = (1 << 10);
    NT_GPIOA->OUTENSET_bit.OUTENSET |= (1 << 10);
    NT_GPIOB->ALTFUNCSET_bit.ALTFUNCSET = (1 << 15);
    NT_GPIOB->OUTENSET_bit.OUTENSET |= (0 << 15);
    //выходы ацп
    NT_GPIOB->ALTFUNCSET_bit.ALTFUNCSET = (1 << 14);
    NT_GPIOB->OUTENSET_bit.OUTENSET |= (1 << 14);
    NT_GPIOB->ALTFUNCSET_bit.ALTFUNCSET = (1 << 13); // поменять если не запашет!!!!
    NT_GPIOB->OUTENSET_bit.OUTENSET |= (1 << 13);
    //Настройка ножек под светодиоды
    NT_GPIOC->ALTFUNCCLR_bit.ALTFUNCCLR = (1 << 13);
    NT_GPIOC->OUTENSET_bit.OUTENSET |= (1 << 13);
    NT_GPIOC->ALTFUNCCLR_bit.ALTFUNCCLR = (1 << 14);
    NT_GPIOC->OUTENSET_bit.OUTENSET |= (1 << 14);
    NT_GPIOC->ALTFUNCCLR_bit.ALTFUNCCLR = (1 << 15);
    NT_GPIOC->OUTENSET_bit.OUTENSET |= (1 << 15);
    NT_GPIOD->ALTFUNCCLR_bit.ALTFUNCCLR = (1 << 13);
    NT_GPIOD->OUTENSET_bit.OUTENSET |= (1 << 13);
    NT_GPIOD->ALTFUNCCLR_bit.ALTFUNCCLR = (1 << 14);
    NT_GPIOD->OUTENSET_bit.OUTENSET |= (1 << 14);
    NT_GPIOD->ALTFUNCCLR_bit.ALTFUNCCLR = (1 << 15);
    NT_GPIOD->OUTENSET_bit.OUTENSET |= (1 << 15);
    NT_GPIOE->ALTFUNCCLR_bit.ALTFUNCCLR = (1 << 2);
    NT_GPIOE->OUTENSET_bit.OUTENSET |= (1 << 2);
    NT_GPIOE->ALTFUNCCLR_bit.ALTFUNCCLR = (1 << 3);
    NT_GPIOE->OUTENSET_bit.OUTENSET |= (1 << 3);
    NT_COMMON_REG->GPIOPCTLB_bit.PIN13 = 2;
    NT_COMMON_REG->GPIOPCTLB_bit.PIN14 = 2;
    NT_COMMON_REG->GPIOPCTLB_bit.PIN15 = 2;
    NT_COMMON_REG->SPI_CLK_bit.DIV_SPI2 = 0x1;
    NT_COMMON_REG->SPI_CLK_bit.DIVEN_SPI2 = 0x1;
    NT_COMMON_REG->SPI_CLK_bit.CLKEN_SPI2 = 0x1;
    NT_SPI2->SPI_CR0_bit.DSS = 0xd;
    NT_SPI2->SPI_CR0_bit.FRF = 0b00; // 00 - spi протокол обмена
    NT_SPI2->SPI_CR0_bit.SPO = 0b1; // полярность
    NT_SPI2->SPI_CR0_bit.SPH = 0b1;   // 0 - передний фронт
    NT_SPI2->SPI_CR0_bit.SCR = 0x2; //коэффициент деления
    NT_SPI2->SPI_CR1_bit.SOD = 0b0;  // пока 0 - идет обмен
    NT_SPI2->SPI_CR1_bit.MS = 0b0;   // 0 - режим работы "мастер"
    NT_COMMON_REG->UART_SPI_CLK_SEL_bit.SEL_SPI2 = 0b00;
    NT_SPI2->SPI_CR1_bit.SSE = 0b1;
}
// Объявление переменных
int i=0;                         //счетчик задержки
bool busy; 						 //флаг занятости АЦП
unsigned short report;			 //
signed short res;                //промежуточные результаты
float result;                    //значение в Вольтах
// Задержка
void delay() {
	for (i = 0;i < 100000; i++) { }
}
// Сброс Convst A и B
void ResetConvstAB() {
	PA8_ON;
	PA8_OFF;
	PA8_ON;
}
// Сброс АЦП
void ResetADC() {
	PA10_OFF;
	PA10_ON;
	PA10_OFF;
	report = 0;
}
//Сброс светодиодов
void ResetLED() {
	delay();
	VD16_ON;
	VD15_ON;
	VD14_ON;
	VD13_ON;
	VD11_ON;
	VD10_ON;
	VD9_ON;
	VD8_ON;
}
//Мигание светодиодами
void LedBlink() {
	if ((result > 4.375) &(result < 5.0)) {
		VD16_OFF;
		delay();
	}
	if ((result > 3.75) &(result < 4.375)) {
		VD15_OFF;
	}
	if ((result > 3.125) &(result < 3.75)) {
		VD14_OFF;
	}
	if ((result > 2.5) &(result < 3.125)) {
		VD13_OFF;
	}
	if ((result > 1.875) &(result < 2.5)) {
		VD11_OFF;
	}
	if ((result > 1.25) &(result < 1.875)) {
		VD10_OFF;
	}
	if ((result > 0.625) &(result < 1.25)) {
		VD9_OFF;
	}
	if ((result >= 0) &(result < 0.625)) {
		VD8_OFF;
	}
}
// Чтение данных с АЦП
void ReadData() {
	while(1) {
		busy = NT_GPIOA->DATA &(1<<12);
		if (busy == false) {
			PB13_OFF;
			NT_SPI2->SPI_DR_bit.DATA = 0x3ff;
			report = NT_SPI2->SPI_DR_bit.DATA;
			if (report > 0) {
				report = report << 2;
				res = (signed short)report;
				res = res >> 2;
				result = res / CONST_ADC;
				ResetLED();
				LedBlink();
			}
			PB13_ON;
			break;
		}
	}
}
// Процесс обмена с АЦП
void ExchangeADC() {
ResetConvstAB();
while (1) {
	busy = NT_GPIOA->DATA &(1<<12);
	if (busy == true) {
		ReadData();
		break;
	}
	}
}

int16 main (void) {
//Инициализация микроконтроллера
	InitCLK();
//Инициализация периферии
	LED_init();
	ResetADC();
	while(1) {
		ExchangeADC();
	}
}

/*@}*/

