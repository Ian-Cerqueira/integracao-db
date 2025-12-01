SELECT
    dim_origem.rubrica_receita_nome,
    SUM(fato.receita_arrecadada) AS valor_total_arrecadado_livre
FROM
    analytics_etl.tabela_fato AS fato 
JOIN
    analytics_etl.dim_origem AS dim_origem
    ON fato.id_origem = dim_origem.id_origem 
WHERE
    fato.fonte_recurso_codigo = 'RECURSO NÃO VINCULADO' 
GROUP BY
    dim_origem.rubrica_receita_nome
ORDER BY
    valor_total_arrecadado_livre DESC 
LIMIT 10;
