WITH receitas_ordenadas AS (
    SELECT
        e.orgao_nome,
        t.ano,
        SUM(f.receita_arrecadada) AS receita_total_anual,
        ROW_NUMBER() OVER (
            PARTITION BY t.ano
            ORDER BY SUM(f.receita_arrecadada) DESC, e.orgao_nome ASC
        ) AS rank_receita
    FROM 
        analytics_etl.tabela_fato AS f
        INNER JOIN dim_tempo AS t
            ON f.id_tempo_sk = t.id_tempo_sk
        INNER JOIN dim_entidade AS e
            ON f.id_entidade_sk = e.id_entidade_sk
    GROUP BY
        e.orgao_nome,
        t.ano
)
SELECT
    orgao_nome,
    ano,
    receita_total_anual
FROM receitas_ordenadas
WHERE rank_receita <= 5
ORDER BY ano, rank_receita;