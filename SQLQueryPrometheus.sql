-- 1 Identifique os alunos que alcançaram a nota máxima (10) em pelo menos uma avaliação cujo tipo tem peso superior a 0.5. Retorne o nome do aluno, a data em que a matrícula correspondente foi realizada e a descrição da avaliação em que a nota máxima foi obtida.

-- nome aluno / data da matricula / descrica

SELECT al.Nome as NomeAluno,
       ma.DataMatricula as DataMatricula,
       av.TituloDescritivo as DescricaoAvaliacao
FROM Aluno AS al
    INNER JOIN Matricula AS ma
        ON ma.IdAluno = al.Id
    INNER JOIN MatriculaAvaliacao AS mt
        ON mt.IdMatricula = ma.Id
    INNER JOIN Avaliacao AS av
        ON av.Id = mt.IdAvaliacao
    INNER JOIN TipoAvaliacao AS ta
        ON ta.Id = av.IdTipoAvaliacao
WHERE mt.Nota = 10 AND ta.Peso > 0.5;