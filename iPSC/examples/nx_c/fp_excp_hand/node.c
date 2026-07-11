/*
     Test program to demostrate the floating point exception handler.
 	
 	This program is designed to run on the host.  There is nothing
 	special done to get the exception handler installed, it is part
 	of the standard fortran runtime library.  If floating point 
 	exceptions are genereated the exception handler performs the
 	proper fixup and the your code will continue executing as
 	normal.
*/
#define cw 0x13bc

main()

{
      double x,y,z;
      int k;
      double sqrt();
      int cdum;
      char logmsg[72];

/*
	The C compiler default 80287 control word is set so that FP
	interrupts are masked, load it now so that those interrupts
	are not masked and an exception will occur
*/
      cdum=ldcw87(cw); 


/*
	test DHEX
*/
      syslog(0,"test dhex");
      x = 1.0;
      for (k = 1; k < 14; ++k)
         x = 16.0*x + k;
      xout(x);fout(x);     

/*
	-1/0
*/
      syslog(0,"-1/0");
      y = -1.0;
      z = 0.0;
      x = y/z;
      xout(x);
 
/*
	denormal
*/
      syslog(0,"denormal");
      y = 1.0e-305;
      z = y / 1.0e10;
      xout(z);
 
/*
	tiny + denormal
*/
      syslog(0,"tiny + denormal");
      x = y + z;
      xout(x);
 
/*
	promote denormal
*/
      syslog(0,"promote denormal");
      x = z * 1.0e10;
      xout(x);
 
/*
	1.0 + promote denormal
*/
      syslog(0,"1.0 + promoted denormal");
      y = 1.0 + x;
      xout(y);
      fout(y);
 
/*
	sqrt(denormal)
*/
      syslog(0,"sqrt(denormal)");
      x = sqrt(z);
      xout(x);
 
/*
	overflow
*/
      syslog(0,"overflow");
      y = 1.0e+250;
      z = y*y;
      xout(z);
 
/*
	sqrt(overflow)
*/
      syslog(0,"sqrt(overflow)");
      x = sqrt(z);
      xout(x);
 
/*
	0/0	
*/
      syslog(0,"0/0");
      x = 0.0;
      y = 0.0;
      z = x/y;
      xout(z);
 
/*
	sqrt(0/0)
*/
      syslog(0,"sqrt(0/0)");
      x = sqrt(z);
      xout(x);
}

/*
	fout -- syslogs a floating double
*/
fout(x)
      double x;
{
      char string[72];

      sprintf(string,"%-23.15le",x);
      syslog(0,string);
}

/*
	xout -- syslogs a floating double in HEX
*/
xout(x)
      double x;
{
      char string[72];

      dhex(x,string);
      syslog(0,string);
}
