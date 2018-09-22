all:
	bison -d parser.y
	flex -o scanner.lex.c scanner.l
	gcc -o etapa2 main.c scanner.lex.c parser.tab.c -lfl -lm
