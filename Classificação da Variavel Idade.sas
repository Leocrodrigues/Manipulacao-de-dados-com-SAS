/* Declaração da biblioteca da AluraPlay*/
LIBNAME alura '/home/u59759055/AluraPlay';

/*CLASSIFICAÇÃO DA VARIÁVEL IDADE*/

/*Cria uma variavel que classifica a Idade em  Faixas*/
PROC RANK
	data=alura.cadastro_cliente_v3
	out=base_ranks
	groups=5;
	var Idade;
	ranks Faixa_Idade;
RUN;

/*Tabela de frequencias*/
PROC FREQ
	data=base_ranks;
	table Faixa_Idade;
RUN;
	
/**/
/*Ordendando pela faixa de idade*/
PROC SORT
	data=base_ranks;
	by Faixa_Idade;
RUN;
	
/*PROC UNIVARIATE
	data=base_ranks;
	var Idade;
	by Faixa_Idade;
RUN;*/	

PROC MEANS
	data=base_ranks noprint;
	var Idade;
	by Faixa_Idade;
	output out=base_faixas_idade
		(drop=_TYPE_ _FREQ_)
		N=Quantidade
		MIN=Minimo
		MAX=Maximo;
RUN;

/*Sumariza  a base pelas faixas de idade usando summary*/	
PROC SUMMARY
	data=base_ranks;
	var Idade;
	by Faixa_Idade;
	output out=base_faixas_idade
		(drop=_TYPE_ _FREQ_)
		N=Quantidade
		MIN=Minimo
		MAX=Maximo;
RUN;

/* */ 
/*Sumariza a base pelas faixas de idade usando o SQL*/ 
PROC SQL;	
	create table alura.FAIXAS_IDADE as
	select Faixa_Idade label="Faixas de Idade", 
		count(*) AS Quantidade label="Quantidade de Clientes", 
		min(Idade) as Minimo label="Mínimo da Idade na faixa", 
		max(Idade) as Maximo label="Máximo da Idade na faixa"
	from base_ranks
	group by Faixa_Idade
;QUIT;
