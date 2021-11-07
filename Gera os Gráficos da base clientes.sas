/* Declaração da biblioteca da AluraPlay*/
LIBNAME alura '/home/u59759055/AluraPlay';

/*Criando as variaveis de Estado e Idade na base cadastro de clientes */
PROC FORMAT;
	VALUE estados_
		low - 09 = "Grande SP"
		10 - 19 = "Interior SP"
		20 - 28= "Rio de Janeiro"
		30 - 39 = "Minas Gerais"
		80 - 87 = "Paraná"
		OTHER = "Demais Estados";
RUN;

Data alura.cadastro_cliente_v3;
set alura.cadastro_cliente_v2;

Estado = put(input(substr(CEP,1,2), best.), estados_.);

Idade = intck('YEAR',input(Nascimento,YYMMDD10.),mdy(12,1,2017),'c');

RUN;

/*Gera uma tabela de frequência das variáveis de Estado e Idadde*/
PROC FREQ
	data = alura.cadastro_cliente_v3;
	table Estado Idade;
RUN;


/*GRÁFICOS*/

/*Plota o gráfico da variável Estado*/
TITLE "Quantidade de Cliente por Estado"
PROC SGPLOT
	data=alura.cadastro_cliente_v3;
	vbar Estado / fillattrs=(color=blue);
	yaxis label="Número de clientes"
		values=(0 to 35 by 5) grid
		minor minorcount=4;
	title "Quantidade de Cliente por Estado";
RUN;

/* Gráfico Idade dos clientes*/
TITLE "Número de clientes por faixas de idade";
PROC SGPLOT
	data=alura.cadastro_cliente_v3;
	HISTOGRAM idade / fillattrs=(color=blue);
	yaxis grid minor minorcount=9 label="Número de Clientes";
	xaxis grid minor minorcount=9 label="Idade(anos)";
RUN;
TITLE;

/* ANÁLISE UNIVARIADA*/
PROC UNIVARIATE
	data=alura.cadastro_cliente_v3;
	var Idade;
	histogram;
RUN;

