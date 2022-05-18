/*---------------------------------------------------*/
/* TEST2 : A test program for using time functions   */


#include <avr/io.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
#include <avr/signal.h>
#include <avr/sleep.h>
#include "stime.h"
#include "suart.h"

#define	SYSCLK		8000000


/*------------------------------------------------*/
/* Global variables                               */

char pool[40];	/* Console input buffer */


volatile struct {	/* Real Time Clock */
	uint8_t tick;	/* 1 sec tick flag */
	uint8_t ms10;	/* Fractional counter in unit of 1/100 sec */
	time_t	utc;	/* Real time counter in UTC format */
} rtc;


/*------------------------------------------------*/
/* Interval Timer (100Hz)                         */

SIGNAL(SIG_OUTPUT_COMPARE1A)
{
	if(++rtc.ms10 >= 100) {
		rtc.utc++;
		rtc.ms10 = 0;
		rtc.tick = 1;
	}
}


/*------------------------------------------------*/
/* Print a time of the UTC time                   */

void show_time (time_t *utc)
{
	static const prog_char days[] = "Sun\0Mon\0Tue\0Wed\0Thu\0Fri\0Sat";
	struct tm *tmr;


	tmr = gmtime(utc);			/* Get time from UTC */

	if(tmr)
		xmitf(PSTR("%u/%u/%u(%s) %2u:%02u:%02u\r\n"),
			tmr->tm_year+1900, tmr->tm_mon+1, tmr->tm_mday, &days[tmr->tm_wday*4],
			tmr->tm_hour, tmr->tm_min, tmr->tm_sec);
}


/*------------------------------------------------*/
/* Online Monitor                                 */

void online (void)
{
	char *cp;
	uint16_t res;
	struct tm *tmptr;
	time_t utc;


	xmitstr(PSTR("\r\ntest2.c sample program for simple time functions\r\n"));
	xmitstr(PSTR("t <year> <month> <day> <hour> <min> <sec> - set initial time\r\n"));
	xmitstr(PSTR("g - start main()\r\n"));


	for(;;) {
		xmitstr(PSTR("\r\n>"));			/* Prompt */
		rcvrstr(pool, sizeof(pool));	/* Console input */
		cp = pool;

		switch (*cp++) {	/* Pick a header char (command) */
			case '\0' :		/* Blank line */
				break;

			case 'g' :		/* g command (start main) */
				xmit('\n');
				return;

			case 't' :		/* t command (set initial time) */
				tmptr = &time_tm;					/* shared buffer */
				if(!pickval(&cp, &res, 10)) break;	/* Year */
				tmptr->tm_year = res - 1900;
				if(!pickval(&cp, &res, 10)) break;	/* Month */
				tmptr->tm_mon = res - 1;
				if(!pickval(&cp, &res, 10)) break;	/* Day in M */
				tmptr->tm_mday = res;
				if(!pickval(&cp, &res, 10)) break;	/* Hour */
				tmptr->tm_hour = res;
				if(!pickval(&cp, &res, 10)) break;	/* Min */
				tmptr->tm_min = res;
				if(!pickval(&cp, &res, 10)) break;	/* Sec */
				tmptr->tm_sec = res;

				utc = mktime(tmptr);				/* Get UTC from time */

				if(utc >= 0) {
					rtc.utc = utc;
					xmitf(PSTR("\nRTC was set to 0x%04X%04X, "), (uint16_t)(utc >> 16), (uint16_t)utc);
					show_time(&utc);
				} else {
					xmitstr(PSTR("\nInvalid time."));
				}
				break;

			default :		/* Unknown command */
				xmitstr(PSTR("\n???"));
		}
		
	}
}


/*------------------------------------------------*/
/* Hardware initializations                       */

void initio(void)
{

	/* Initialize ports */
	PORTB = 0b10111111;
	DDRB  = 0b01100000;
	DDRB  = 0b01000000;

	set_sleep_mode(SLEEP_MODE_IDLE);

	/* Enter online mode when an ISP cable is active (MOSI is pulled low) */
	if(bit_is_clear(PINB, 5))
		online();

	/* Start TC1 with 100Hz OC-A */
	OCR1A = SYSCLK / 64 / 100;
	TCCR1B = _BV(CTC1) | _BV(CS11) | _BV(CS10);	/* CTC, 1/64  */
	TIMSK = _BV(OCIE1A);	/* Enable SIG_OUTPUT_COMPARE1A */

	sei();

}


/*------------------------------------------------*/
/* Main Process (Clock)                           */


int main(void)
{
	time_t utc;

	initio();

	for(;;) {
		sleep_mode();
		if(rtc.tick == 0) continue;

		cli();
		utc = rtc.utc;
		rtc.tick = 0;
		sei();
		show_time(&utc);
	};

}

