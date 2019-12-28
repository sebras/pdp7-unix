char *name1 = NULL;
char *name2 = NULL;
char *char = 0;
int parflg = 0;
int labflg = 0;

char buf[500];
char *bp = &buf[0] - 1;

char lbuf[10];
char *lbp = &lbuf[0] - 1;

int nwds;

wbuf()
{
	write(outf, buf, nwds)
	nwds = 0;
	bp = &buf[0] - 1;
}

error()
{
	printf(*char);
	printf(" ?\n");
	parflg = 0;
	labflg = 0;
}

a(int dir)
{
	direc = dir;

	if (delx < 0)
		delx = ~delx + 1

	int dist = dely;
	if (dist < 0)
	{
		dist = ~dist + 1;
	}

	dist += delx - 4;
	if (dist >= 0)
		dist = 0;

	dist += 3;

	tmp = dist + incxp;
	incx = *tmp;

	tmp = dist + incyp;
	incy = *tmp;

}

b(int dir)
{
	direc = dir;
	dist = 0;
	incx = *incxt;
	incy = *incyt;
}

main(int argc, char **argv)
{
	name1 = argv[2];
	name2 = argv[1];

	if (argc == 1)
	{
		// no arguments given
		name1 = ttyout;
		name2 = ttyin;
	}
	else if (argc == 2)
	{
		// one arguments given, output filename
		name2 = ttyin;
	}
	else
	{
		// two arguments given, output and input filenames
	}

	int inf;
	if ((inf = open(name2, O_RDONLY)) < 0)
	{
		printf("%s", name2);
		printf(" ?\n");
		exit();
	}

	int outf;
	if ((outf = open(namel, O_WRONLY)) < 0)
	{
		if (creat(name1, "usr+rw,oth+rw") < 0)
		{
			printf("%s", name1);
			printf(" ?\n");
			exit();
		}
	}

	nchar = 0;
	x = 0;
	y = 0;
	parflg = 0;
	nins = 0;
	nwds = 0;

	bp = &buf[0] - 1;

	while (true)
	{
		char = nchar;
		nchar = 0;

		if (char == 0)
		{
			if (read(inf, &char, 2) == 0)
			{
				close(inf);
				wbuf();
				close(outf);
				exit();
			}

			nchar = (*char) & 0x1ff;
			char >>= 9;
		}

		if (labflg)
		{
			if (*char == '\n')
				labflg = 0;

			*lbp++ = *char;
		}
		else if (parflg)
		{
			if (*char < 'a' || *char > 'n')
			{
				error();
			}
			else
			{
				nx = *char - 'a';

				while (true)
				{
					delx = nx + ~(x - 1);
					dely = ny + ~(y - 1);

					if (delx < 0 && dely < 0)
						b(5);
					if (delx < 0 && dely == 0)
						a(6);
					if (delx < 0 && dely > 0)
						b(7);
					if (delx == 0 && dely < 0)
						a(4);
					if (delx == 0 && dely == 0)
						break;
					if (delx == 0 && dely > 0)
						a(0);
					if (delx > 0 && dely < 0)
						b(3);
					if (delx > 0 && dely == 0)
						a(2);
					if (delx > 0 && dely > 0)
						b(1);

					nins++;

					mod3++;
					if (mod3 == 0)
					{
						*bp++ = '\n'; *bp++ = '0';
						nwds++;
						mod3 = -3;
					}

					ac = (dist << 4) | vis | direc;

					mq = ac;
					ac <<= 12;

					ac = 0;
					ac <<= 3;
					ac <<= 6
					ac <<= 3;

					ac += 060060;
					
					*bp++ = ac;
					nwds++;

					tmp = direc + incx;
					x += *tmp;

					tmp = direc + incy;
					y += *tmp;
				}

				x = nx;
				y = ny;
				parflg = 0;
			}
		}
		else if (*char == '\n')
			continue;
		else if (*char == ':')
		{
			labflg = -4;
			mod3 = -4;
			wbuf();

			lbp = &lbuf[0] - 1

			*bp++ = 'x'; *bp++ = ':'; nwds++;
			*bp++ = '\n'; nwds++;
			*bp++ = '0'; nwds++;
		}
		else if (*char == 'x')
		{
			vis = 0;
		}
		else if (*char == 'v')
		{
			vis = 0x8;
		}
		else if (*char == 'r')
		{
			while (++mod3 < 0)
			{
				*bp++ = '0'; *bp++ = '0';
				nwds++;

			}

			*bp++ = '\n';
			nwds++;

			lbp = &lbuf[0] - 1

			while (*lbp != '\n')
			{
				*bp = *lbp;
				nwds++;
				bp++;
				lbp++;
			}

			*bp++ = '='; *bp++ = 'x'; nwds++;
			*bp++ = '-'; *bp++ = 'b'; nwds++;
			*bp++ = '+'; *bp++ = '0'; nwds++;

			tmp = nins + 0100;
			nins = 0;

			*bp++ = '0' + ((tmp >> 15) & 0x7);
			*bp++ = '0' + ((tmp >> 12) & 0x7);
			*bp++ = '0' + ((tmp >> 9) & 0x7);
			*bp++ = '0' + ((tmp >> 6) & 0x7);
			*bp++ = '0' + ((tmp >> 3) & 0x7);
			*bp++ = '0' + ((tmp >> 0) & 0x7);
			*bp++ = '\n';
			*bp++ = '\n';

			nwds += 4;

			x = 0;
			y = 0;
		}
		else
		{
			if (*char < 'a' || *char > 'p')
			{
				error();
			}
			else
			{
				ny = ~(*char - 'a' - 16) - 3;
				parflg = -1;
			}
		}
	}
}
