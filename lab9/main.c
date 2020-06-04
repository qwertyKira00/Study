#include <stdio.h>
#include <math.h>
//-objdump --disassemble hd (дизассемблирование)
//-objdump -f hd (адрес запуска программы)

int main(){


	double a;
	printf("Enter a coefficient:\n");
	scanf("%lf", &a);

	double b;
	printf("Enter b coefficient:\n");
	scanf("%lf", &b);

	double c;
	printf("Enter c coefficient:\n");
	scanf("%lf", &c);

	if (a == 0 && b == 0)
	{
		printf("No solutions\n");
		return 0;
	}

	double d;
	d = b * b - 4 * a * c;

	if (d > 0)
	{
		double x1, x2;

		x1 = -b + sqrt(d) / (2 * a);
		x2 = -b - sqrt(d) / (2 * a);
		printf("x1 = %lf\nx2 = %lf\n", x1, x2);
		return 0;
	}
	else if (d == 0)
	{
		double x;

		x = -b / (2 * a);
		printf("x = %lf\n", x);
		return 0;
	}
	else
	{
		printf("No solutions");
		return 0;
	}

	return 0;

}
