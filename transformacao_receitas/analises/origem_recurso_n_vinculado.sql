SELECT
    dim_origem.rubrica_receita_nome,
    ROUND(SUM(fato.receita_arrecadada),2) AS valor_total_arrecadado_livre
FROM
    analytics_etl.tabela_fato AS fato 
JOIN
    analytics_etl.dim_origem AS dim_origem
    ON fato.id_origem_sk = dim_origem.id_origem_sk 
WHERE 
    fato.fonte_recurso_nome ILIKE 'RECURSOS NÃO VINCULADOS'
GROUP BY
    dim_origem.rubrica_receita_nome
ORDER BY
    valor_total_arrecadado_livre DESC 
LIMIT 10;
