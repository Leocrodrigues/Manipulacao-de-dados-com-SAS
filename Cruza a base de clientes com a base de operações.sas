/* Declaração da biblioteca da AluraPlay*/
LIBNAME alura '/home/u59759055/AluraPlay';

/* AVALIAR QUANTOS JOGOS CADA CLIENTE ALUGOU EM 201709*/

PROC CONTENTS
	data=alura.operacoes_201709 varnum;
RUN;

PROC CONTENTS
	data=alura.cadastro_cliente_v3 varnum;
RUN;


/* Criando uma tabela e visualiazando o cpf e quanto jogos aluagram cada um*/
PROC SQL;
	create table contratos_cpf as
	select CPF, count(*) as Quantidade_Jogos
	from alura.operacoes_201709
	group by CPF /*agrupando a base operacoes pelo cpf*/
;QUIT;

/*CONVERTER O CPF DA BASE DE CLIENTES  EM CPF RAIZ(SEM OS DOIS ULTIMOS DIGITOS)*/
DATA cad_cli_cpf_raiz;
set alura.cadastro_cliente_v3;

CPF_RAIZ = input(substr(CPF,1,11),COMMAX11.0);
RUN;
/*ORDERNAR A BASE DE CLIENTES*/
PROC SORT
	data=cad_cli_cpf_raiz
	out=cad_cli_cpf_sort /*criando uma nova base de saída pra nao alterar a original*/
	nodupkey; /*nao queremos chaves duplicadas*/
	by CPF_RAIZ; /*variavel q vai ser ordenada*/
RUN;

/*Ordenando a base produtos*/
PROC SORT
	data=alura.operacoes_201709
	out=cad_oper_2017 /*criando uma nova base de saída pra nao alterar a original*/
	nodupkey; /*nao queremos chaves duplicadas*/
	by COD_PRODUTO; /*variavel q vai ser ordenada*/
RUN;
/*Checando a base*/
PROC CONTENTS data=cad_cli_cpf_sort; RUN;
PROC CONTENTS data=contratos_cpf; RUN;

/*Cruzamento das bases usando data merge*/
DATA cad_cli_jogos;
	merge cad_cli_cpf_sort (in=A) /*definindo um ponteiro*/
	contratos_cpf
	(rename=(CPF=CPF_RAIZ)); /*renomeando para cpf raiz*/
by CPF_RAIZ; /*LIGANDO PELO CPF*/
IF A=1; /*se o ponteiro(cpf) for igual a 1 ok, se nao nao mostra*/
RUN;

PROC PRINT data=cad_cli_jogos;RUN;
PROC PRINT data=contratos_cpf;RUN;


DATA jogos_alugados;
	merge cad_oper_2017 (in=A)
  	alura.cadastro_produto_v3
  	(in=B rename=(Numero=COD_PRODUTO));
by COD_PRODUTO;
if A and B;
RUN;