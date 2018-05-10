parser: lex.yy.o y.tab.o symbols.o
	gcc -o a y.tab.o symbols.o -lfl

lex.yy.o: scanner.l
	flex scanner.l
	gcc -c -g lex.yy.c

y.tab.o: project2.y
	byacc project2.y
	gcc -c -g y.tab.c

symbols.o: symbols.c symbols.h
	gcc -c -g symbols.c

clean:
	rm -f *.o lex.yy.c y.tab.c
