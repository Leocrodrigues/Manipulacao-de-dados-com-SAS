/*Análise da variavel  de data da base de cadastro de produto*/
/*CHECAR  E CORRIGIR VARIAVEL DATA*/

/*Checa se existem datas são preenchidas*/
PROC FREQ
	data = alura.cadastro_produto_v2;
	table Data;
RUN;

/* Checa os jogos que nao tem data preenchida as data missing(.) */
Data teste1;
set  alura.cadastro_produto_v2;
WHERE data is missing; /* ou data = .; */
RUN;

/*confere o preenchimento das datas nas demais cópias dos jogos*/
PROC FREQ
	data = alura.cadastro_produto_v2
		(where=(nome in ("Fireshock" "Forgotten Echo" "Soccer")));
	table nome*data
	/list missing;
RUN;

/*corrige a data*/
DATA teste2;
set alura.cadastro_produto_v2;

IF data = . and nome = "Fireshock" THEN data = 201706; ELSE
IF data = . and nome = "Forgotten Ech" THEN data = 201411; ELSE
IF data = . and nome = "Soccer" THEN data = 201709; 

RUN;


/* Igual a condição acima, porém aqui ja declaramos o IF do data = . antes para todas as outras*/
DATA teste2;
set alura.cadastro_produto_v2;

IF data = . THEN DO; /* criando a condição com missing data = . para todas as tres*/
	IF nome = "Fireshock" THEN data  = 201706; ELSE
	IF nome = "Forgotten Ech" THEN data = 201411; ELSE
	IF nome = "Soccer" THEN data = 201709; 
end;
RUN;


DATA teste2;
set alura.cadastro_produto_v2;

IF data = . THEN DO;
	SELECT(nome);
		WHEN ("Fireshock") data = 201706;
		WHEN ("Forgotten Ech") data = 201411;
		WHEN ("Soccer") data = 201709;
		OTHERWISE;
	END;
END;
RUN;
		
PROC FREQ
	data = teste2
		(where=(nome in ("Fireschock" "Forgotten Ech" "Soccer")));
	table nome*data
	/list missing;
RUN;
		
/*criando as variaveis flag lançamento e flag antigo na nova base produto v3*/
DATA alura.cadastro_produto_v3;
set teste2;

IF data > 201606
	THEN flag_lancamento = 1;
	ELSE flag_lancamento = 0;
	
IF data < 201401
	THEN flag_antigo = 1;
	ELSE flag_antigo = 0;
	
label
	flag_lancamento = "Marca 1 para jogos que são lançamento e 0 caso contrário "
	flag_antigo = "Marca 1 para jogos lançados antes de 2014 e 0 caso contrário";
RUN;

/*conferindo se existe valores missing*/
PROC FREQ
	data = alura.cadastro_produto_v3
		(where=(nome in ("Fireshock" "Forgotten Ech" "Soccer")));
	table nome*data
	/list missing;
RUN;

/*Comparandos as duas bases e podemos ver q a v3 agr esta correta*/
PROC FREQ
	data = alura.cadastro_produto_v2;
	table flag_lancamento flag_antigo;
RUN;

PROC FREQ
	data = alura.cadastro_produto_v3;
	table flag_lancamento flag_antigo;
RUN;

/*Criando uma nova variavel*/
/*Se o jogo foi lançado depois de junho de 2016 ela recebe é preenchida com o valor da variável Preco menos 10*/
/*Se o jogo foi lançado antes do ano de 2014, ela recebe é preenchida com o valor da variável Preco acrescida de 
10% do seu valor o equivalente a multiplicar a variável Preco por 1.1*/
/*Caso a data não atenda nenhuma das condições acima, a variável é preenchida com o valor da variável Preco*/
Data desafio;
set alura.cadastro_produto_v3;

IF data  > 201606 THEN DO;
	identificador_idade = "Lançamento";
	preco_ajustado = preco -10;
END;
	ELSE IF data < 201401 then do;
	identificador_idade = "Antigo";
	preco_ajustado = preco*1.1;
	END;
		ELSE DO;
			identificador_idade = "Outro";
			preco_ajustado = preco;
			END;
RUN;

/*Criando uma nova variavel */
DATA base_nova;
set alura.cadastro_produto_v3;

FORMAT texto_lancamento $6.; /*definindo o tamanho */

if data > 201606
    then texto_lancamento = "Novo";
    else texto_lancamento = "Antigo";

RUN;
