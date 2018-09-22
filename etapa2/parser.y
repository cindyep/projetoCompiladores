%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
int return_value = 0;  
void yyerror (char const *s);

void yyerror (char const *s)
{
	
	return_value = 1;
	printf("ERRO!\n");
	

}


%}
%error-verbose

%token TK_PR_INT
%token TK_PR_FLOAT
%token TK_PR_BOOL
%token TK_PR_CHAR
%token TK_PR_STRING
%token TK_PR_IF
%token TK_PR_THEN
%token TK_PR_ELSE
%token TK_PR_WHILE
%token TK_PR_DO
%token TK_PR_INPUT
%token TK_PR_OUTPUT
%token TK_PR_RETURN
%token TK_PR_CONST
%token TK_PR_STATIC
%token TK_PR_FOREACH
%token TK_PR_FOR
%token TK_PR_SWITCH
%token TK_PR_CASE
%token TK_PR_BREAK
%token TK_PR_CONTINUE
%token TK_PR_CLASS
%token TK_PR_PRIVATE
%token TK_PR_PUBLIC
%token TK_PR_PROTECTED
%token TK_OC_LE
%token TK_OC_GE
%token TK_OC_EQ
%token TK_OC_NE
%token TK_OC_AND
%token TK_OC_OR
%token TK_OC_SL
%token TK_OC_SR
%token TK_OC_FORWARD_PIPE
%token TK_OC_BASH_PIPE
%token TK_LIT_INT
%token TK_LIT_FLOAT
%token TK_LIT_FALSE
%token TK_LIT_TRUE
%token TK_LIT_CHAR
%token TK_LIT_STRING
%token TK_IDENTIFICADOR
%token TOKEN_ERRO

%%

/* PROGRAMA NA LINGUAGEM */
program:
	declaration |
	program declaration
	;


/* ELEMENTOS QUE COMPÕEM UM PROGRAMA */
declaration: 
	function |
	global ';'
	;

global: 
	global_variable_decl |
	user_type_decl
	;

//// TIPOS ////

primitive_type:
	TK_PR_INT |
	TK_PR_FLOAT |
	TK_PR_BOOL |
	TK_PR_CHAR |
	TK_PR_STRING
	;

all_types:
	primitive_type |
	user_type
	;

//////////////

//// INICIO DECLARAÇÕES DE NOVOS TIPOS ////
/* TIPO CLASS */
user_type_decl:  	
	TK_PR_CLASS TK_IDENTIFICADOR '[' field_list ']' 
	;

user_type:
	TK_IDENTIFICADOR '[' field_list ']' 
	;

/* CAMPO */
field:
	encapsulation_type primitive_type TK_IDENTIFICADOR | 
	primitive_type TK_IDENTIFICADOR
	;

/* LISTA DE CAMPO */
field_list: 
	field |
	field_list ':' field
	;

/* TIPO DE ENCAPSULAMENTO */
encapsulation_type:
	TK_PR_PRIVATE |
	TK_PR_PUBLIC |
    TK_PR_PROTECTED
    ;

//// FIM DECLARAÇÕES DE NOVOS TIPOS ////

//// INÍCIO DECLARAÇÕES DE VARIÁVEIS GLOBAIS ////

global_variable_decl:
	TK_IDENTIFICADOR all_types |
	TK_IDENTIFICADOR TK_PR_STATIC all_types |
	TK_IDENTIFICADOR TK_IDENTIFICADOR |
	array_decl
	;

array_decl:
	TK_IDENTIFICADOR '[' TK_LIT_INT ']' all_types |
	TK_IDENTIFICADOR '[' TK_LIT_INT ']' TK_PR_STATIC all_types
	;  

//// FIM DECLARAÇÕES DE VARIÁVEIS GLOBAIS ////

//// INÍCIO DEFINIÇÃO DE FUNÇÕES ////

function:
	function_header function_body
	;

/* CABEÇALHO DA FUNÇÃO */
function_header: //type não pode ser vetor
	function_related_type TK_IDENTIFICADOR '(' parameter_list ')' |
	TK_IDENTIFICADOR TK_IDENTIFICADOR '(' parameter_list ')' |
	TK_PR_STATIC function_related_type TK_IDENTIFICADOR '(' parameter_list ')' |
	function_related_type TK_IDENTIFICADOR '(' ')' |
	TK_PR_STATIC function_related_type TK_IDENTIFICADOR '(' ')' 
	;

function_related_type:
	TK_PR_INT |
	TK_PR_FLOAT |
	TK_PR_BOOL |
	TK_PR_CHAR |
	user_type
	;

parameter_list:
	parameter |
	parameter_list ',' parameter
	;

parameter:
	function_related_type TK_IDENTIFICADOR |
	TK_IDENTIFICADOR TK_IDENTIFICADOR |
	TK_PR_CONST function_related_type TK_IDENTIFICADOR 
	;

/* CORPO DA FUNÇÃO */
function_body:
	command_block
	;

//// FIM DEFINIÇÃO DE FUNÇÕES ////

//// INÍCIO BLOCO DE COMANDOS ////
command_block:
	'{' '}' |
	'{' sequence '}'
	;

sequence:
	command ';' |
	case_command |
	command ';' sequence 
	;
	
command:
	command_block |
	local_var_declaration |
    attribution |
	flow_control |
	input_command |
	output_command |
	return_command |
	function_call |
	shift_command |
	break_command |
	continue_command |
	pipes_exp
	;

local_var_decl:
	primitive_type TK_IDENTIFICADOR local_var_att |
	TK_IDENTIFICADOR TK_IDENTIFICADOR
	;

local_var_att:
	TK_OC_LE value_init |
	//empty
	;


local_var_declaration:
	local_var_decl|
	TK_PR_STATIC local_var_decl|
	TK_PR_STATIC TK_PR_CONST local_var_decl |
	TK_PR_CONST local_var_decl 
	;


value_init:
	TK_IDENTIFICADOR |
	literal
	;

literal:
	TK_LIT_INT |
	TK_LIT_FLOAT |
	TK_LIT_FALSE |
	TK_LIT_TRUE |
	TK_LIT_CHAR |
	TK_LIT_STRING
	;

/* COMANDO DE ATRIBUIÇÃO */
attribution:
	primitive_atr |
	user_type_atr
	;

primitive_atr: 
	TK_IDENTIFICADOR '=' expression_or_literal_or_variable |
	TK_IDENTIFICADOR '[' literal ']' '=' expression_or_literal_or_variable |
	TK_IDENTIFICADOR '[' expression ']' '=' expression_or_literal_or_variable
	;

user_type_atr:
	TK_IDENTIFICADOR '$' expression '=' expression_or_literal_or_variable |
	TK_IDENTIFICADOR '$' literal '=' expression_or_literal_or_variable |
	TK_IDENTIFICADOR '[' expression ']' '$' expression_or_literal '=' expression_or_literal_or_variable |
	TK_IDENTIFICADOR '[' literal ']' '$' expression_or_literal '=' expression_or_literal_or_variable
	;

expression_or_literal:
	expression |
    literal 
    ;

expression_or_literal_or_variable:
	expression_or_literal |
    TK_IDENTIFICADOR '[' literal ']' |
    TK_IDENTIFICADOR '[' expression ']'
    ;

/* COMANDOS DE ENTRADA E SAÍDA */

input_command:
	TK_PR_INPUT expression
	;

output_command:
	TK_PR_OUTPUT expression_list
	;

expression:
   	arithmetic_exp |
   	logical_exp |
   	pipes_exp |
	TK_IDENTIFICADOR
	;
	
expression_list:
    expression |
    expression_list ',' expression
    ;
 
// CHAMADA DE FUNÇÃO

function_call:
	function_name '(' argument_list ')'
	;

function_name:
	TK_IDENTIFICADOR
	;

argument_list:
	argument |
	argument_list ',' argument
	;

argument:
	expression |
	'.' |
	//empty
	;

// COMANDOS DE SHIFT
shift_command: 
	id_types TK_OC_SL number_or_expression |
	id_types TK_OC_SR number_or_expression
	;

id_types:
	TK_IDENTIFICADOR |
	TK_IDENTIFICADOR '[' expression ']' | 
	TK_IDENTIFICADOR '$' TK_IDENTIFICADOR |
	TK_IDENTIFICADOR '[' expression ']' '$' TK_IDENTIFICADOR
	;

number_or_expression:
	TK_LIT_INT |
	expression
	;

// COMANDO DE RETORNO, BREAK, CONTINUE E CASE 
return_command:
	TK_PR_RETURN expression
	;

break_command:
	TK_PR_BREAK
	;

continue_command:
	TK_PR_CONTINUE
	;

case_command:
	TK_PR_CASE TK_LIT_INT ':'
	;

/* COMANDOS DE CONTROLE DE FLUXO: */
flow_control:
	command_if |
	command_while |
	command_foreach |
	command_for |
	command_do_while |
	command_switch_case
	;

command_if:
	TK_PR_IF '(' expression ')' TK_PR_THEN command_block |
	TK_PR_IF '(' expression ')' TK_PR_THEN command_block else
	;

else:
	TK_PR_ELSE command_block
	;

command_foreach:
	TK_PR_FOREACH '(' TK_IDENTIFICADOR  ':' expression_list ')' command_block
	;

command_for:
	TK_PR_FOR '(' for_expression ')' command_block
	;

for_expression:
	command_list_for ':' expression ':' command_list_for
	;

command_list_for:
	commands_for_for |
	command_list_for ',' commands_for_for
	;

commands_for_for: //NÃO PODE CONTER ',' DENTRO DE COMANDOS >> SIMPLES <<
	command_block |
	local_var_declaration |
    attribution |
	input_command |
	shift_command
	;

command_while:
	TK_PR_WHILE '(' expression ')' TK_PR_DO command_block
	;

command_do_while:
	TK_PR_DO command_block TK_PR_WHILE '(' expression ')'
	;

command_switch_case:
	TK_PR_SWITCH '(' expression ')' command_block
	;

/* COMANDOS COM PIPES */
pipe_command:
	function_call pipes function_call  |
    pipe_command pipes function_call 
	;

pipes:
	TK_OC_FORWARD_PIPE |
	TK_OC_BASH_PIPE
	;
	    
/* TIPOS DE EXPRESSÃO */
 arithmetic_exp: 
 	arithmetic_operand arithmetic_operator_binary arithmetic_operand |
 	arithmetic_exp arithmetic_operator_binary arithmetic_operand |
 	arithmetic_operand arithmetic_operator_binary '(' arithmetic_exp ')'
 	;

arithmetic_operand:
	arithmetic_operator_unary arithmetic_operand_type |
	arithmetic_operand_type
	;

arithmetic_operand_type:
 	TK_IDENTIFICADOR |
 	TK_IDENTIFICADOR '[' TK_LIT_INT ']' |
 	TK_IDENTIFICADOR '[' arithmetic_exp ']' |
 	TK_LIT_INT |
 	TK_LIT_FLOAT |
 	function_call
 	;

arithmetic_operator_unary:
	'+' |
	'-'
	;

arithmetic_operator_binary:
	'+' |
	'-' |
	'*' |
	'/' |
	'%' |
	'^'
	;

logical_exp:								//revisar operadores '?'
	arithmetic_exp relational_comp arithmetic_exp |
	logical_exp logical_op_binary TK_IDENTIFICADOR |
	logical_op_unary TK_IDENTIFICADOR
	;

logical_op_unary:
	'!' |
	'?'
	;

logical_op_binary:
	TK_OC_AND |
	TK_OC_OR
	;

relational_comp:
	TK_OC_LE |
    TK_OC_GE |
    TK_OC_EQ |
    TK_OC_NE |
    '<' |
	'>'
    ;

pipes_exp:									//revisar ? uma sequencia com pipes ?
	pipe_command |
	TK_IDENTIFICADOR '$' TK_IDENTIFICADOR pipe_operation expression |
	TK_IDENTIFICADOR '[' expression ']' '$' field  pipe_operation expression
	;

pipe_operation: 
	TK_OC_FORWARD_PIPE |
	TK_OC_BASH_PIPE
	;
/*
pipe_elements:
	TK_IDENTIFICADOR |
 	TK_IDENTIFICADOR '[' TK_LIT_INT ']' |
 	TK_IDENTIFICADOR '$' TK_IDENTIFICADOR |
 	TK_LIT_INT |
 	TK_LIT_FLOAT |
 	function_call
 	;
*/
//// FIM BLOCO DE COMANDOS ////

%%
