/*Associando o diretório dos dados ao nome alura*/
LIBNAME alura "/home/u59759055/AluraPlay";

/*Visualizando o dataset*/
PROC DATASETS
	lib=alura details;
RUN;

/* Buscando conteúdo de uma base específica*/
PROC CONTENTS
	data=alura.cadastro_produto;
RUN;

/*Imprimindo uma base na saída*/
PROC PRINT
	data=alura.cadastro_produto;
RUN;

/*Relátorio de frequência de genero, plataforma e nome*/
PROC FREQ
	data=alura.cadastro_produto nlevels; /*nlevels número de classes por váriavel*/
	table genero plataforma nome;
RUN;

/*Criando uma opção GLOBAL*/
OPTIONS obs=15;

/*Criando um novo dataset chamado teste com os dados da cadastro produto*/
DATA teste;
set alura.cadastro_produto;

/*definindo o tamanho da variavel lançamento e antigo como 3*/
LENGTH lancamento 3;
LENGTH antigo 3;
/*Criando uma variavel para lançamento de jogos de acordo com ano especificado*/
IF data > 201606
	THEN lancamento  = 1;
	ELSE lancamento = 0;
/*Criando uma variavel antiga para jogos lançados antess de 2014 */	
IF data < 201401
	THEN antigo = 1;
	ELSE antigo = 0;
RUN;

/*Fazendo print na nova base teste*/
PROC PRINT	
	DATA=TESTE;
RUN;

/*Fazendo frequência da nova base*/
PROC FREQ 
	data=teste;
	table lancamento;
RUN;


/*Fazendo a frequência da variavel DE JOGOS antigo*/
PROC FREQ 
	data=teste;
	table antigo;
RUN;

/*Fazendo print na nova base teste sem a coluna obs*/
PROC PRINT	
	DATA=TESTE noobs;
RUN;

/*Qual genero tem mais lancamentos?*/
PROC FREQ
	data=teste;
	table genero *lancamento
	/nocol norow nopercent; /*informando que nao quero a frequencia da coluna, linhas e o percentual;
RUN;

/* Analisando o numero de classes, fazendo o cruzamento entre genero e plataforma e tabela nome*/
PROC FREQ
	data=alura.cadastro_produto nlevels;
	table nome genero*plataforma;
RUN;

/*Frequencia do nome dos jogos e quantas classes(nomes diferentes) temos*/
PROC FREQ
	data=alura.cadastro_produto nlevels;
	table nome;
	table nome*genero /*cruzando tabela nome  e genero*/
	/list;
RUN;
/* concluimos que na verdade temos 42 classes de nomes, porém um nome possui n generos*/

/*Frequencia acumulada da célula*/
PROC FREQ	
	data=alura.cadastro_produto;
	table plataforma*genero
	/list nopercent;
RUN;

/*Frequencia e percentual sem o acumulado*/
PROC FREQ	
	data=alura.cadastro_produto;
	table plataforma*genero
	/list nocum;
RUN;

/*criando um novo dataset utilizando a base teste*/
DATA alura.cadastro_produto_v2;
set teste;
/*renomeando uma variavel*/
rename lancamento = flag_lancamento;
rename antigo= flag_antigo;
label Genero = "Gênero"
	lancamento = "Marca 1 para jogos que são lançamento e 0 caso contrário "
	antigo = "Marca 1 para jogos lançados antes de 2014 e 0 caso contrário";
RUN;

/*Verificando o conteúdo da base*/
PROC CONTENTS
	data=alura.cadastro_produto_v2;
RUN;

	