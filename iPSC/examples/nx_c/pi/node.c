/***********************************************************************
*
*			Node Program
*
*	Approximate pi with the n-point rectangle quadrature rule
*	applied to the integral from 0 to 1 of 4 / (1+x**2)
*
*	pi = h * sum from i = 1 to n of f(xi)
*
*	where  h = 1/n
*	       xi=(i-1/2)*h
*	       f(x)=4 / (1+x**2)
*
***********************************************************************/

#define intsize 2

int pid,cid,id,dim,type,cnt,root,rnid,rpid;
int copen(),cubedim(),mynode();
int n,p,i;
double x,sum,pi,h,work;

main() { /* node program */

	double f();

/*
	Open communications area
*
	Find node number, cube dimension, number of processors
*/

	pid = 0;
	cid = copen(pid);
        id = mynode();
	dim = cubedim();
	p = 1<<dim;

/*
	Use global receive to get n from the host.
*/

	n = 1;
	while(n > 0) {
	   type = 1;
	   recvw(cid,type,&n,intsize,&cnt,&rnid,&rpid);

/*
	   Compute this node's partial sum
	   Partial sums are interleaved
*/

	   if (n > 0) {
	      h = 1.0 / n;
	      sum = 0.0;
	      for (i=id+1; i<=n; i=i+p) {
	         x = (i-0.5) * h;
		 sum = sum + f(x);
	      }

	      pi = h * sum;

/*
	      Use global sum to assemble partial sums and send result to host
*/

	      type = 2;
	      root = 0x8000;
	      gop(cid,type,&pi,1,'+',root,dim,&work);
	   }
	}

}

double f(x)
double x;

{

  return(4/(1+x*x));

}
