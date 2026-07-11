/*
     Test program to demostrate the floating point exception handler.
 	
 	This program is designed to run on the host.  There is nothing
 	special done to get the exception handler installed, it is part
 	of the standard fortran runtime library.  If floating point 
 	exceptions are genereated the exception handler performs the
 	proper fixup and the your code will continue executing as
 	normal.
*/
     
main()

{
      double x,y,z;
      int k;
      double sqrt();
      int fpeh();

/*  
	Call to fpeh does two things:

		1) loads control word with "correct" mask
		2) calls signal to set handler address

	fpeh is in the module fpeh.c in this directory
*/
      fpeh();


/*
	test DHEX
*/
      printf("test dhex");
      x = 1.0;
      for (k = 1; k < 14; ++k)
         x = 16.0*x + k;
      xout(x);fout(x);     

/*
	-1/0
*/
      printf("\n-1/0");
      y = -1.0;
      z = 0.0;
      x = y/z;
      xout(x);
 
/*
	denormal
*/
      printf("\ndenormal");
      y = 1.0e-305;
      z = y / 1.0e10;
      xout(z);
 
/*
	tiny + denormal
*/
      printf("\ntiny + denormal");
      x = y + z;
      xout(x);
 
/*
	promote denormal
*/
      printf("\npromote denormal");
      x = z * 1.0e10;
      xout(x);
 
/*
	1.0 + promote denormal
*/
      printf("\n1.0 + promoted denormal");
      y = 1.0 + x;
      xout(y);
      fout(y);
 
/*
	sqrt(denormal)
*/
      printf("\nsqrt(denormal)");
      x = sqrt(z);
      xout(x);
 
/*
	overflow
*/
      printf("\noverflow");
      y = 1.0e+250;
      z = y*y;
      xout(z);
 
/*
	sqrt(overflow)
*/
      printf("\nsqrt(overflow)");
      x = sqrt(z);
      xout(x);
 
/*
	0/0	
*/
      printf("\n0/0");
      x = 0.0;
      y = 0.0;
      z = x/y;
      xout(z);
 
/*
	sqrt(0/0)
*/
      printf("\nsqrt(0/0)");
      x = sqrt(z);
      xout(x);

      printf("\n");
}



/*
	fout -- outputs a floating double
*/
fout(x)
      double x;
{
      char string[72];

      printf(string,"	|%-23.15le",x);
}


/*
	xout -- outputs a floating double in HEX
*/
xout(x)
      double x;
{
      char string[72];

      dhex(x,string);
      printf("	%s",string);
      
}
