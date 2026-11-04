#include <stdio.h>

int main() {
    /* erase graphics screen */
    char *erase = "\033PpS(E)\033\\";

    /* draw a square */
    char *square = "\033PpS(I0)S(D0)P[110,110]v[+100,+0][+0,+100][-100,+0][+0,-100]\033\\";

    /* draw a thing (from nested (B) and (E) commands */
    char *nestle = "\033Ppp[200,100] v(b)[200,200] (b)v[300,400] v[400,300] v(e)c[+5] v[100,50] v(e)c[+10]\033\\";

    /* meander a bit using a temporary scaling and pixel vectors */
    char *meander = "\033Ppp[350,50]V(W(M5))00607665544432222202020223334455556\033\\";

    char buffer[128];

    printf("%s\n", erase);
    printf("%s\n", square);
    printf("%s\n", nestle);
    printf("%s\n", meander);

    /* draw stacked circles */
    {
        int i;
        printf("\033Pp");  /* preamble */
	printf("p[400,400]"); /* moveto */
	for (i = 0; i < 5; i++) {
            printf("C[+%d,+%d]", i * 10, i * 10);
        }
        printf("\033\\"); /* end of ReGIS command */
    }

    return 0;

} /* main */
