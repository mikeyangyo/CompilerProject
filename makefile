parser: y.tab.h lex.yy.o y.tab.o symbols.o
	gcc -o a y.tab.o symbols.o -lfl

y.tab.h: project2.y
	byacc -d project2.y

lex.yy.o: scanner.l y.tab.h
	flex scanner.l
	gcc -c -g lex.yy.c

y.tab.o: y.tab.c
	gcc -c -g y.tab.c

symbols.o: symbols.c symbols.h
	gcc -c -g symbols.c

clean:
	rm -f *.o lex.yy.c y.tab.c y.tab.h
