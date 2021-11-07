/*Declaração da biblioteca alura*/
LIBNAME alura "/home/u59759055/AluraPlay";

/*Checando a base cadastro de cliente v2*/
PROC CONTENTS
DATA=alura.cadastro_cliente_v2;
RUN;

/* CALCULA A IDADE DOS CLIENTES */

DATA cad_cli_idade;
set alura.cadastro_cliente_v2;

*data_nascimento= input(nascimento,YYMMDD10.); /*CONVERTENDO PARA DATA*/
*hoje = mdy(12,1,2017); /* definindo a data atual como esta*/

/*Cálculo da idade*/
*idade = int((hoje-data_nascimento)/365);
*idade = intck('YEAR',data_nascimento,hoje);

idade = intck('YEAR',input(nascimento,YYMMDD10.),mdy(12,1,2017),'c');

*FORMAT data_nascimento DDMMYY10. hoje DDMMYY10.; /* colocando formato BR*/

RUN;

/*Visualizando a base*/
PROC PRINT data=cad_cli_idade;
RUN;

