%option yylineno
%{
#include "parser.tab.h"
%}
digit         [0-9]
letter        [a-zA-Z]
integer       ("+"|"-")?{digit}+
%%

"," return ',';
";" return ';';
":" return ':';
"(" return '(';
")" return ')';
"[" return '[';
"]" return ']';
"{" return '{';
"}" return '}';
"+" return '+';
"-" return '-';
"|" return '|';
"?" return '?';
"*" return '*';
"/" return '/';
"<" return '<';
">" return '>';
"=" return '=';
"!" return '!';
"&" return '&';
"%" return '%';
"#" return '#';
"^" return '^';
"." return '.';
"$" return '$';

"<=" return TK_OC_LE;
">=" return TK_OC_GE;
"==" return TK_OC_EQ;
"!=" return TK_OC_NE;
"&&" return TK_OC_AND;
"||" return TK_OC_OR;
">>" return TK_OC_SR;
"<<" return TK_OC_SL;
"%>%" return TK_OC_FORWARD_PIPE;
"%|%" return TK_OC_BASH_PIPE;

"int"       return TK_PR_INT;
"float"     return TK_PR_FLOAT;
"bool"      return TK_PR_BOOL;
"char"      return TK_PR_CHAR;
"string"    return TK_PR_STRING;
"if"        return TK_PR_IF;
"then"      return TK_PR_THEN;
"else"      return TK_PR_ELSE;
"while"     return TK_PR_WHILE;
"do"        return TK_PR_DO;
"input"     return TK_PR_INPUT;
"output"    return TK_PR_OUTPUT;
"return"    return TK_PR_RETURN;
"const"     return TK_PR_CONST;
"static"    return TK_PR_STATIC;
"foreach"   return TK_PR_FOREACH;
"for"       return TK_PR_FOR;
"switch"    return TK_PR_SWITCH;
"case"      return TK_PR_CASE;
"break"     return TK_PR_BREAK;
"class"     return TK_PR_CLASS;
"continue"  return TK_PR_CONTINUE;
"private"   return TK_PR_PRIVATE;
"public"    return TK_PR_PUBLIC;
"protected" return TK_PR_PROTECTED;

"false"     return TK_LIT_FALSE;
"true"      return TK_LIT_TRUE;

({letter}|_)({letter}|{digit}|_)* 				return TK_IDENTIFICADOR;
\'.\' 	    		return TK_LIT_CHAR;
\"(.)*\"			return TK_LIT_STRING;
{integer} 			return TK_LIT_INT;
{integer}\.{integer}(("E"|"e"){integer})? 	return TK_LIT_FLOAT;

\'.(.)+\'					 return TOKEN_ERRO;
\'\'						 return TOKEN_ERRO;
("//").*					{/*ignorar*/}
"/*"(.|"\n")*"*/"     		{/*ignorar*/}
(" "|"	")*					{/*ignorar*/}
.							return TOKEN_ERRO;


\n { }
[ \t\r\f]+ { }

%%

int get_line_number(void) {
  return yylineno;
}
