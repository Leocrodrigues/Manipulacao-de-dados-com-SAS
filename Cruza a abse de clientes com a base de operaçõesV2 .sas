/* Declaração da biblioteca da AluraPlay*/
LIBNAME alura '/home/u59759055/AluraPlay';

/* Criando uma tabela e visualiazando o cpf e quanto jogos aluagram cada um*/
PROC SQL;
	create table contratos_cpf as
	select CPF, count(*) as Quantidade_Jogos
	from alura.operacoes_201709
	group by CPF /*agrupando a base operacoes pelo cpf*/
;QUIT;

/*CONVERTER O CPF DA BASE DE CLIENTES  EM CPF RAIZ(SEM OS DOIS ULTIMOS DIGITOS)*/
DATA cad_cli_cpf_raiz;;
set alura.cadastro_cliente_v3;
CPF_RAIZ = input(substr(CPF,1,11),COMMAX11.0);
RUN;

/*Cruzamento das bases usando o PROC SQL*/

PROC SQL ;
	CREATE TABLE cadastro_cliente_jogos AS
	SELECT A.*, B.Quantidade_Jogos
	FROM cad_cli_cpf_raiz AS A
	LEFT JOIN contratos_cpf AS B
	ON A.CPF_RAIZ = B.CPF
;QUIT;

/*mesma tabela que acima, porém nao contém cpf raiz*/
PROC SQL;
	CREATE TABLE cadastro_cliente_jogos AS
	SELECT A.*, B.Quantidade_Jogos
	FROM alura.cadastro_cliente_v3 AS A
	LEFT JOIN contratos_cpf AS B
	ON input(substr(A.CPF,1,11),COMMAX11.0) = B.CPF
;QUIT;

/*Fazendo com uma sub select*/
PROC SQL;
	CREATE TABLE cadastro_cliente_jogos AS
	SELECT A.*, B.Quantidade_Jogos
	FROM alura.cadastro_cliente_v3 AS A
	LEFT JOIN ( 
		select CPF, count(*) as Quantidade_Jogos
		from alura.operacoes_201709
		group by CPF) AS B
	ON input(substr(A.CPF,1,11),COMMAX11.0) = B.CPF
;QUIT;


PROC PRINT data=alura.operacoes_201709;RUN;

/*Codigo Auxiliar*/
PROC SQL;
	CREATE TABLE CONTRATOS_VALIDOS_CPF AS
	SELECT *,
		DATA_RETORNO - DATA_RETIRADA AS DIAS,
		CASE WHEN CALCULATED DIAS > 30 OR CUSTO_REPARO > 0
			THEN 0
			ELSE 1
			END AS FLAG_VALIDA
	FROM alura.operacoes_201709
;QUIT;


/*USANDO HAVING*/
PROC SQL;
	CREATE TABLE CONTRATOS_VALIDOS_CPF AS
	SELECT *,
		DATA_RETORNO - DATA_RETIRADA AS DIAS,
		CASE WHEN CALCULATED DIAS > 30 OR CUSTO_REPARO > 0
			THEN 0
			ELSE 1
			END AS FLAG_VALIDA
	FROM alura.operacoes_201709
	HAVING FLAG_VALIDA = 1 /*MANTENDO OS VALORES CUJO SEJA IGUAL A 1*/
;QUIT;


/*Fazendo Sumarização*/
PROC SQL;
	CREATE TABLE CONTRATOS_VALIDOS_CPF AS
	SELECT CPF,
		COUNT(*) AS TOTAL_CONTRATOS, 
		SUM(CASE WHEN DATA_RETORNO - DATA_RETIRADA > 30 OR CUSTO_REPARO > 0
			THEN 0
			ELSE 1
			END) AS CONTRATOS_VALIDOS
	FROM alura.operacoes_201709
	GROUP BY CPF
;QUIT;

/*Adicionando a base de clientes o total de jogos e quantiade de operações validas*/
PROC SQL;
	CREATE TABLE alura.cadastro_cliente_jogos AS
	SELECT A.*, B.TOTAL_CONTRATOS, B.CONTRATOS_VALIDOS
	FROM alura.cadastro_cliente_v3 AS A
	LEFT JOIN ( 
		SELECT CPF,
			COUNT(*) AS TOTAL_CONTRATOS, 
			SUM(CASE WHEN DATA_RETORNO - DATA_RETIRADA > 30 OR CUSTO_REPARO > 0
				THEN 0
				ELSE 1
				END) AS CONTRATOS_VALIDOS
	FROM alura.operacoes_201709
	GROUP BY CPF) AS B
	ON input(substr(A.CPF,1,11),COMMAX11.0) = B.CPF
;QUIT;


