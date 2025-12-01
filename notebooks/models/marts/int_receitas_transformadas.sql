{{
    config(
        materialized='view'
    )
}}

-- 1. CTEs para pegar os dados brutos de cada tabela que seu Python carregou

with raw_2021 AS (
    SELECT *, '2021' AS ano_dados FROM raw."2021_receitas_transformadas"
),

raw_2022 AS (
    SELECT *, '2022' AS ano_dados FROM raw."2022_receitas_transformadas"
),

raw_2023 AS (
    SELECT *, '2023' AS ano_dados FROM raw."2023_receitas_transformadas"
),

-- 2. Unificando tudo em um lugar só

stg_receitas_transformadas AS (
    SELECT * FROM raw_2021
    UNION ALL
    SELECT * FROM raw_2022
    UNION ALL
    SELECT * FROM raw_2023
),

-- 3. Tratamento de Tipos e Limpeza de Moeda

tratamento_valores AS (
    SELECT
        -- Mantemos as colunas de identificação
        ano_dados,
        mes,
        orgao_nome,
        orgao_codigo,
        unidade_nome,
        unidade_codigo,
        categoria_economica_nome,
        categoria_economica_codigo,
        rubrica_receita_nome,
        rubrica_receita_codigo,
        fonte_recurso_nome,
        fonte_recurso_codigo,
        subfonte_receita_nome,
        subfonte_receita_codigo,
        
        -- Tratamento das colunas de valor (R$ 1.000,00 -> 1000.00)
        -- Removemos 'R$', removemos o ponto de milhar e trocamos a vírgula por ponto
        CAST(NULLIF(REGEXP_REPLACE(receita_prevista, '[^0-9,]', '', 'g'), '') AS NUMERIC) / 100 AS receita_prevista,
        CAST(REPLACE(REPLACE(REPLACE(receita_prevista_acrescimo, 'R$', ''), '.', ''), ',', '.') AS NUMERIC) AS receita_prevista_acrescimo,
        CAST(REPLACE(REPLACE(REPLACE(receita_prevista_atualizada, 'R$', ''), '.', ''), ',', '.') AS NUMERIC) AS receita_prevista_atualizada,
        CAST(REPLACE(REPLACE(REPLACE(receita_arrecadada, 'R$', ''), '.', ''), ',', '.') AS NUMERIC) AS receita_arrecadada

    FROM
        stg_receitas_unificadas
),