-- 1 Liste o nome de cada classe de embarque junto com a quantidade total de bilhetes emitidos para ela, 
--ordenando do maior para o menor.

-- exibir nome de cada classe / quantidade total de bilhetes
-- group by para agrupar a quantidade com as classes
-- order by desc == maior para o menor

SELECT cl.Nome as NomeEmbarque,
	   COUNT(em.Id) as QuantidadeTotalBilhetes
	FROM ClasseEmbarque AS cl
		INNER JOIN Embarque AS em
			ON em.IdClasseEmbarque = cl.Id
	GROUP BY cl.Nome
	ORDER BY QuantidadeTotalBilhetes DESC;

-- 2 Mostre o nome e o país de cada companhia aérea, exibindo também o total de voos que ela operou.

-- nome do pais de companhia aerea / nome do pais / total de voos que ela operou
-- agrupar companhia aeria por voos UMA companhia aerea vai ter MUITOS voos

SELECT cp.Nome as NomeCompanhia,
       cp.PaisDeOrigem as NomePais,
	   COUNT(vo.Id) as QuantidadeVoos
	FROM CompanhiaAerea AS cp
		INNER JOIN Voo AS vo
			ON vo.IdCompanhiaAerea = cp.Id
	GROUP BY cp.Nome, cp.PaisDeOrigem;
	
-- 3 Liste cada status operacional acompanhado da quantidade de voos atualmente nesse status, incluindo status que não têm nenhum voo associado.

-- nome de status operacional / quantidade de voos
-- condicao: mostrar status que nao possuem voos com LEFT JOIN
-- agrupar status com voo Um status vai ter VARIOS voos

SELECT st.Nome as StatusVoo,
	   COUNT(vo.Id) as QuantidadeVoos
	FROM StatusOperacional AS st
		LEFT JOIN Voo AS vo
			ON vo.IdStatusOperacional = st.Id
	GROUP BY st.Nome

-- 4 Apresente o código IATA, o nome da companhia e a duração média (em minutos) dos voos por ela operados, ordenado pela duração média do maior para o menor.

-- mostrar codigo IATA / nome da companhia / duracao media dos voos
-- agrupar a media por IATA e nome da companhia UM codigo IATA e companhia vao ter MUITAS duracaoVoo(possibilitando media)
-- ordenar do maior para o menor com ORDER BY DESC

SELECT cp.CodigoIATA as CodigoIATA,
	   cp.Nome as NomeCompanhia,
	   AVG(vo.DuracaoEstimada) as MediaDuracaoVooEmMinutos
	FROM CompanhiaAerea AS cp
		INNER JOIN Voo AS vo
			ON vo.IdCompanhiaAerea = cp.Id
	GROUP BY cp.CodigoIATA, cp.Nome
	ORDER BY MediaDuracaoVooEmMinutos DESC;

-- 5 Mostre o nome dos passageiros que têm mais de 40 anos de idade e cuja primeira letra do nome esteja entre 'A' e 'M'.

-- nome dos passageiros
-- condicao/where: "tem MAIS de 40 anos", primeira letra do nome com "A" E/AND "M"
-- sem group by
-- sem order by

SELECT pa.NomeCompleto as NomeCompleto
	FROM Passageiro AS pa
	WHERE pa.DataNascimento > DATEADD(YEAR, -40, GETDATE()) AND LEFT(pa.NomeCompleto, 1) BETWEEN 'A' AND 'M';

-- 6 Liste os aeroportos cujo nome contém a palavra "Internacional", exibindo também a cidade e o país onde estão localizados.

-- nome dos aeroporto / cidade e pais
-- condicao/where: contem a palavra internacional nos seus nomes

SELECT ae.Nome as NomeAeroporto,
	   en.Cidade as Cidade,
	   en.Pais as Pais
	FROM Aeroporto AS ae
		LEFT JOIN Endereco AS en
			ON en.Id = ae.IdEndereco
	WHERE ae.Nome LIKE '%Internacional%';

-- 7 Para cada companhia aérea, mostre quantos voos ela opera em cada status operacional, 
-- formando uma tabela com nome da companhia, status e quantidade.

-- nome da companhia, status da companhia e quantidade de voos
-- sem condicao?
-- group by para pegar a quantidade de voos

SELECT COUNT(vo.Id) as QuantidadeVoos,
	   st.Nome as NomeStatus,
	   cp.Nome as NomeCompanhia
	FROM CompanhiaAerea as cp
		LEFT JOIN Voo AS vo
			ON vo.IdCompanhiaAerea = cp.Id
		LEFT JOIN StatusOperacional AS st
			ON st.Id = vo.IdStatusOperacional
	GROUP BY st.Nome, cp.Nome;

-- 8 Apresente, para cada classe de embarque, a média do número da poltrona ocupada, 
-- o menor e o maior valor de poltrona, e o desvio-padrão das poltronas.

SELECT AVG(em.NumeroPoltrona) as MediaNumeroPoltrona,
	   MIN(em.NumeroPoltrona) as MenorNumeroPoltrona,
	   MAX(em.NumeroPoltrona) as MaiorNumeroPoltrona,
	   STDEV(em.NumeroPoltrona) as DesvioPadrao,
	   cl.Nome as ClassePoltrona
	FROM ClasseEmbarque AS cl
		INNER JOIN Embarque AS em
			ON cl.Id = em.IdClasseEmbarque
	GROUP BY cl.Nome;

-- 9 Para cada classe de embarque, mostre a quantidade de bilhetes emitidos e a porcentagem que essa quantidade representa em relação ao total de bilhetes do sistema.

-- quantidade de bilhetes emitidos / nome de cada classe de embarque / porcentagem
-- agrupar a classe de embarque

SELECT cl.Nome as NomeClasse,
	   COUNT(em.Id) as QuantidadeBilhetesEmitidos
	FROM ClasseEmbarque AS cl
		LEFT JOIN Embarque AS em
			ON em.IdClasseEmbarque = cl.Id
	GROUP BY cl.Nome;

-- 10 Liste as cidades que possuem mais de um aeroporto cadastrado, exibindo a cidade, o país e a quantidade de aeroportos.

-- nome das cidades / pais / quantidade de aeroportos
-- agrupar quantidade pelo pais e cidades

SELECT en.Cidade as NomeCidade,
	   en.Pais as NomePais,
	   COUNT(en.Id) as QuantidadeAeroportos
	FROM Endereco AS en
		LEFT JOIN Aeroporto AS ae
			ON ae.IdEndereco = en.Id
	GROUP BY en.Pais, en.Cidade
	HAVING COUNT(en.Id) >= 2;

-- 11 Liste o código de cada voo junto com o nome da companhia, o nome do aeroporto de origem e o nome do aeroporto de destino.

-- codigo de cada voo / nome da companhia / nome do aeroporto de origem / nome aeroporto de destino
-- só?

SELECT vo.CodigoUnico as CodigoVoo,
	   cp.Nome as Nomecompanhia,
	   ad.Nome as AeroportoDestino,
	   ao.Nome as AeroportoOrigem
	FROM Voo AS vo
		LEFT JOIN CompanhiaAerea AS cp
			ON cp.Id = vo.IdCompanhiaAerea
		LEFT JOIN Aeroporto AS ad
			ON ad.Id = vo.IdAeroportoDestino
		LEFT JOIN Aeroporto AS ao
			ON ao.Id = vo.IdAeroportoOrigem;

-- 12 Mostre o nome completo do passageiro, o código do voo embarcado, o nome da classe e o número da poltrona, ordenando por código

-- nome completo do passageiro / codigo do voo / nome da classe / numero poltrona
-- ordernando por codigo

SELECT em.NumeroPoltrona as NumeroPoltrona,
	   pa.NomeCompleto as NomeCompleto,
	   vo.CodigoUnico as CodigoVoo,
	   cl.Nome as NomeClaseEmbarque
	FROM Embarque AS em
		LEFT JOIN Passageiro AS pa
			ON em.IdPassageiro = pa.Id
		LEFT JOIN Voo As vo
			ON vo.Id = em.IdVoo
		LEFT JOIN ClasseEmbarque AS cl
			ON cl.Id = em.IdClasseEmbarque
	ORDER BY vo.CodigoUnico, em.NumeroPoltrona;

-- 13 Liste o código dos voos cujo aeroporto de origem está no Brasil mas o aeroporto de destino está em outro país, exibindo também as cidades de origem e destino.

-- codigo de voo / cidade de origem / cidade de destino
-- condicao/where/having: aeroporto esta no Brasil / aeroporto de destino em outro pais != Brasil

SELECT vo.CodigoUnico as CodigoDeVoo,
	   ao.Nome as AeroportoOrigem,
	   ad.Nome as AeroportoDestino,
	   ed.Cidade as CidadeDestino,
	   eo.Cidade as CidadeOrigem
	FROM Voo AS vo
		INNER JOIN Aeroporto AS ao
			ON ao.Id = vo.IdAeroportoOrigem
		INNER JOIN Aeroporto AS ad
			ON ad.Id = vo.IdAeroportoDestino
		INNER JOIN Endereco AS eo
			ON eo.Id = ao.IdEndereco
		INNER JOIN Endereco AS ed
			ON ed.Id = ad.IdEndereco
	WHERE eo.Pais = 'Brasil' AND ed.Pais != 'Brasil';

-- 14 Mostre, para cada bilhete emitido, o nome do passageiro, a sigla IATA da companhia, o status atual do voo e a data de partida.

-- nome do passageiro / sigla IATA / Status atual do voo / data de partida
--mostrar so os nomes sem filtro?

SELECT pa.NomeCompleto as NomeCompleto,
	   cp.CodigoIATA as CodigoIATA,
	   st.Nome as StatusOperacional,
	   vo.DataHoraPartida as HoraPartida
	FROM Passageiro AS pa
		INNER JOIN Embarque AS em
			ON pa.Id = em.IdPassageiro
		INNER JOIN Voo AS vo
			ON vo.Id = em.IdVoo
		INNER JOIN CompanhiaAerea AS cp
			ON cp.Id = vo.IdCompanhiaAerea
		INNER JOIN StatusOperacional AS st
			ON st.Id = vo.IdStatusOperacional

-- 15 Liste o nome dos passageiros que embarcaram em voos partindo do aeroporto Pinto Martins (Fortaleza), 
-- juntamente com o código do voo e a data de partida.

-- nome dos passageiros / codigo de voo / data partida
-- filtrar pelo aeroporto de origem Pinto Martins (Fortaleza)

SELECT pa.NomeCompleto as NomeCompleto,
	   vo.CodigoUnico as CodigoVoo,
	   vo.DataHoraPartida as DataPartida
	FROM Passageiro AS pa
		INNER JOIN Embarque AS em
			ON em.IdPassageiro = pa.Id
		INNER JOIN Voo AS vo
			ON vo.Id = em.IdVoo
		INNER JOIN Aeroporto AS ao
			ON ao.Id = vo.IdAeroportoOrigem
	WHERE ao.Nome LIKE '%Pinto Martins (Fortaleza)%';

-- 16 Para cada voo, mostre o código, a cidade de origem, a cidade de destino e quantos bilhetes foram emitidos, 
--considerando inclusive voos sem nenhum bilhete (devem aparecer com zero).

-- mostre o codigo / cidade de origem / cidade de destino / quantidade bilhetes
-- considerando voo SEM bilhetes
-- agrupar tudo para quantidade dar certo

SELECT vo.CodigoUnico as CodigoUnico,
	   eo.Cidade as CidadeOrigem,
	   ed.Cidade as CidadeDestino,
	   COUNT(em.Id) as QuantidadeBilhetes
	FROM Voo AS vo
		LEFT JOIN Embarque AS em
			ON em.IdVoo = vo.Id
		LEFT JOIN Aeroporto AS ao
			ON ao.Id = vo.IdAeroportoOrigem
		LEFT JOIN Aeroporto AS ad
			ON ad.Id = vo.IdAeroportoDestino
		LEFT JOIN Endereco AS eo
			ON eo.Id = ao.IdEndereco
		LEFT JOIN Endereco AS ed
			ON ed.Id = ad.IdEndereco
	GROUP BY vo.CodigoUnico, eo.Cidade, ed.Cidade;

-- 17 Para cada passageiro que já embarcou em algum voo, mostre o nome e a quantidade de países distintos 
--que ele já visitou (com base nos países dos aeroportos de destino), 
-- listando apenas os passageiros que visitaram mais de um país.

-- mostrar nome de paises DISTINTOS / quantida de de paises distintos
-- condicao: listar apenas os passageiros que visitaram mais de um pais ( > 1)

SELECT DISTINCT pa.NomeCompleto,
				COUNT(DISTINCT en.Pais) as QuantidadePaises
	FROM Passageiro AS pa
		INNER JOIN Embarque AS em
			ON em.IdPassageiro = pa.Id
		INNER JOIN Voo AS vo
			ON vo.Id = em.IdVoo
		INNER JOIN Aeroporto AS ae
			ON ae.Id = vo.IdAeroportoDestino
		INNER JOIN Endereco AS en
			ON en.Id = ae.IdEndereco
	GROUP BY pa.NomeCompleto
	HAVING COUNT(DISTINCT en.Pais) > 1;

-- 18 Liste os pares de passageiros (sem repetição) que embarcaram em um mesmo voo, 
-- mostrando o código do voo e os dois nomes.

-- sem ideia de onde comecar/ questao mais dificil até agr?

SELECT vo.CodigoUnico as CodigoVoo,
	   pa1.NomeCompleto as Passageiro1,
	   pa2.NomeCompleto as Passageiro2
	FROM Embarque em1
		INNER JOIN Embarque AS em2
			ON em1.IdVoo = em2.IdVoo
		INNER JOIN Passageiro AS pa1
			ON pa1.Id = em1.IdPassageiro
		INNER JOIN Passageiro AS pa2
			ON pa2.Id = em2.IdPassageiro
		INNER JOIN Voo AS vo
			ON vo.Id = em1.IdVoo
	WHERE em1.IdPassageiro < em2.IdPassageiro;

-- 19 Mostre os voos em que pelo menos um passageiro está usando uma classe diferente de "Economica", 
-- trazendo o código do voo, o nome da companhia e a quantidade de bilhetes não-econômicos.

-- codigo do voo / nome da companhia / quantidade de bilhetes não-economicos
-- condicao: voo em que PELO MENOS 1 passageiro tem uma classe != economica

SELECT vo.CodigoUnico as CodigoVoo,
	   cp.Nome as NomeCompanhia,
	   COUNT(em.Id) as QuantidadeBilhetes
	FROM CompanhiaAerea AS cp
		INNER JOIN Voo AS vo
			ON vo.IdCompanhiaAerea = cp.Id
		INNER JOIN Embarque AS em
			ON em.IdVoo = vo.Id
		INNER JOIN ClasseEmbarque AS cl
			ON cl.Id = em.IdClasseEmbarque
	WHERE cl.Nome != 'Economica'
	GROUP BY cp.Nome, vo.CodigoUnico;

-- 20 Para cada companhia aérea, mostre o código do voo de maior duração que ela opera
-- e o seu destino (cidade e país).

-- codigo de voo / cidade / pais
-- agrupar pela companhia aerea
-- condicao: codigo de voo com maior duracao

SELECT vo.CodigoUnico as CodigoVoo,
	   en.Cidade as Cidade,
	   en.Pais as Pais
	FROM Voo AS vo
		INNER JOIN Aeroporto AS ae
			ON ae.Id = vo.IdAeroportoDestino
		INNER JOIN Endereco AS en
			ON en.Id = ae.IdEndereco
	WHERE vo.DuracaoEstimada IN (
							  SELECT MAX(vo1.DuracaoEstimada) as MaiorDuracao
								 FROM Voo AS vo1
								 WHERE vo1.IdCompanhiaAerea = vo.IdCompanhiaAerea
							);

-- 21 Mostre quantos voos cada companhia aérea opera, 
-- exibindo o nome da companhia e o total, listando inclusive companhias sem nenhum voo.

-- quantidade voos cada companhia / nome companhia
-- condicao: mostrar companhias sem nenhum voo

SELECT *
	FROM CompanhiaAerea AS cp
		INNER JOIN 