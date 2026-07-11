/* Prints the number x into the string s in HEX */ 
dhex(x, s)
	double	x;
	char	*s;
	{
	union {
		double	h_d;
		long	h_l[2];
		} hack;

	hack.h_d = x;
	sprintf(s, "%.8lx", hack.h_l[1]);
	sprintf(&s[8], "%.8lx", hack.h_l[0]);
}
