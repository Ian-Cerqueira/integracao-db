
SELECT
    orgao_nome,
    ano,
    receita_total_anual
FROM (
    SELECT
        e.orgao_nome,
        t.ano,
        SUM(f.receita_arrecadada) AS receita_total_anual
    FROM 
         analytics_etl.tabela_fato AS f
        inner JOIN dim_tempo AS t
            ON f.id_tempo_sk = t.id_tempo_sk
        inner JOIN dim_entidade AS e
            ON f.id_entidade_sk = e.id_entidade_sk
    GROUP BY
        e.orgao_nome,
        t.ano
) AS base_anual

WHERE receita_total_anual = (   SELECT 
                                    MIN(a2.receita_total_anual)
                                FROM (
                                    SELECT
                                        t2.ano,
                                        e2.orgao_nome,
                                        SUM(f2.receita_arrecadada) AS receita_total_anual
                                    FROM receitas_etl_final f2
                                    INNER JOIN dim_tempo t2
                                        ON f2.id_tempo_sk = t2.id_tempo_sk
                                    INNER JOIN dim_entidade e2
                                        ON f2.id_entidade_sk = e2.id_entidade_sk
                                    GROUP BY e2.orgao_nome, t2.ano
                                ) a2
                                WHERE a2.ano = base_anual.ano
);