/* Declaração da biblioteca da AluraPlay*/
LIBNAME alura '/home/u59759055/AluraPlay';

/*Checa a base cadastro de cliente*/
PROC CONTENTS data=alura.cadastro_cliente;
RUN;

/* Atribuindo as regioes de acordo com CEP*/
DATA teste1;
set alura.cadastro_cliente;

FORMAT Estado $14.; /*definindo que a variavel estado tem 14 caracteres*/

    if "01000-000" <= cep <="09999-999" then
        Estado="Grande SP";
    else if "10000-000" <= cep <="19999-999" then
        Estado="Interior SP";
    else if "20000-000" <= cep <="28999-999" then
        Estado="Rio de Janeiro";
    else if "30000-000" <= cep <="39999-999" then
        Estado="Minas Gerais";
    else if "80000-000" <= cep <="87999-999" then
        Estado="Paraná";
    else
        Estado="Demais estados";

RUN;

PROC FREQ
	data=teste1;
	table Estado / missing;
RUN;

/* Verificando o contéudo da base*/
PROC CONTENTS
	data=teste1;
RUN;

/*CRIANDO NOVA OPÇÃO GLOBAL*/
options obs =max;

/*Criando um datastep com base temporária*/
Data teste2;
set alura.cadastro_cliente;
/*extraindo subtexto da variavel cep, no caso vamos extrair os dois primeiros digítos e criar uma variavel precep com eles*/
precep = substr(cep,1, 2);
RUN;

/*Convertendo a variavel precep pra numerico direto*/
Data teste2;
set alura.cadastro_cliente;

precep = input(substr(cep,1,2),best.);

RUN;

/*Convertendo a variavel precep pra numerico direto e trazendo só as variáveis que eu quero*/
Data teste2;
set alura.cadastro_cliente (obs=15); /*lendo só 15 linhas*/

precep = input(substr(cep,1,2),best.);
keep CPF CEP precep;

RUN;

/*Convertendo a variavel precep pra numerico direto e trazendo só as variáveis que eu quero*/
Data teste2;
set alura.cadastro_cliente (obs=15 keep=CPF CEP); /*lendo só 15 linhas e CPF E CEP*/

precep = input(substr(cep,1,2),best.);

RUN;

/*Convertendo a variavel precep pra numerico direto e trazendo só as variáveis que eu quero*/
Data teste2;

set alura.cadastro_cliente (obs=15 keep=CPF CEP); /*lendo só 15 linhas e CPF E CEP*/

precep = input(substr(cep,1,2),best.);
RUN;

OPTIONS OBS=max;

/*Criando um formato personalizado de número para texto*/
PROC FORMAT;
	VALUE estados_
	low - 09 = "Grande SP"
	10 - 19 = "Interior SP"
	19< - <29 = "Rio de Janeiro"
	30 - 39 = "Minas Gerais"
	80 - hight = "Região Sul"
	OTHER = "Demais Estados";
RUN;

/*Convertendo a variavel precep pra numerico direto e trazendo só as variáveis que eu quero*/
Data teste2;
set alura.cadastro_cliente (obs=15 keep=CPF CEP); /*lendo só 15 linhas e CPF E CEP*/

estado = put(input(substr(cep,1,2),best.), estados_.); /* convertendo atraves do cep o estado*/

RUN;

/*Criando um  formato personalizado de texto para número*/
PROC FORMAT;
	INVALUE estadosnum_
		low - "09" = 1
		"10" - "19" = 2
		"20" - "28" = 3
		"30" - "39" = 4
		"80" - "87" = 5
		OTHER = 6;
	VALUE estadotxt_
		1 = "Grande SP"
		2 = "Interior SP"
		3 = "Rio de Janeiro"
		4 = "Minas Gerais"
		5 = "Paraná"
		OTHER = "Demais Estados";
RUN;

/*Criando uma nova base cad cliente*/
Data alura.cadastro_cliente_v2;
set alura.cadastro_cliente;

estado = input(substr(cep,1,2), estadosnum_.); /* convertendo atraves do cep o estado*/
format estado estadotxt_.; /* criando a mascacara*/

RUN;

/* Checo minha variavel estado*/
PROC FREQ
	data=alura.cadastro_cliente_v2;
	table estado;
RUN;
/*INPUT DE CARACTER PARA NUMERICO */
/*PUT DE NUMERICO PARA CARACTER*/