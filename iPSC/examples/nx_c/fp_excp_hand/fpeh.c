#include <signal.h>


int fpeh() /*	install Intel 80287 Floating Point Exception Handler */

{
  int sig_fpe();
  int ldcw87();

  /* Call to assembly routine that loads the 80287 mask	*/
  /* with a value that will allow interrupts.  The	*/
  /* default mask in the control word does not allow	*/
  /* exceptions.					*/ 	
  ldcw87(0x13bc);

  /* Call to signal, SIGFPE = 16, this tells XENIX 	*/
  /* for the next exception 16 do not call the default,	*/
  /* call the routine sig_fpe.				*/
  signal(SIGFPE,sig_fpe);

  return;

}

sig_fpe()
{

  /* Call actual exception handler, this routine is	*/
  /* found in the module eh287n.asm.			*/
  ieee_handler();


  /* Call to signal, SIGFPE = 16, this tells XENIX 	*/
  /* for the next exception 16 do not call the default,	*/
  /* call the routine sig_fpe.				*/
  signal(SIGFPE,sig_fpe);
}
