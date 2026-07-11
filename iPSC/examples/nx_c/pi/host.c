/***********************************************************************
*
*			Host Program
*
*	Approximate pi with the n-point rectangle quadrature rule
*	applied to the integral from 0 to 1 of 4 / (1+x**2)
*
***********************************************************************/

#define intsize 2
#define dblsize  8

int cid,type,cnt,nid,pid,rnid,rpid,n;
int copen();
double pi;

main() { /* host program */

/*
	Open communications area
*/

	pid = 0;
	cid = copen(pid);

/*
	Read number of points from user terminal
*/

	n = 1;
	while (n > 0) {
	   printf("\n");
	   printf("Enter n (enter value <= 0 to exit): ");
	   scanf("%d",&n);
/*
	   Send n to all nodes
*/
	   type = 1;
	   nid = -1;
	   sendmsg(cid,type,&n,intsize,nid,pid);
/*
	   Receive the result from one of the nodes
*/
	   if (n > 0) {
	      recvmsg(cid,&type,&pi,dblsize,&cnt,&rnid,&rpid);
	      printf("Value of PI is %.16f\n",pi);
	   } 
	}
}
