SELECT
    e.orgao_nome,
    t.ano,
    AVG(f.receita_arrecadada) AS receita_media_anual
FROM 
    analytics_etl.tabela_fato AS f
    inner JOIN dim_tempo AS t
        ON f.id_tempo_sk = t.id_tempo_sk
    inner JOIN dim_entidade AS e
        ON f.id_entidade_sk = e.id_entidade_sk
GROUP BY
    e.orgao_nome,
    t.ano
ORDER BY
    receita_media_anual DESC;