{{ config(materialized='table') }}

WITH base AS (
    SELECT * FROM {{ ref('int_receitas_transfornadas') }}
),

origem AS (
    SELECT DISTINCT
        categoria_receita_nome,
        fonte_origem_receita_nome,
        rubrica_receita_nome,
        receita_local_nome
    FROM base
    WHERE receita_local_nome IS NOT NULL 
),

    SELECT
        ROW_NUMBER() OVER (
            ORDER BY 
                categoria_receita_nome, 
                fonte_origem_receita_nome, 
                rubrica_receita_nome, 
                receita_local_nome
        ) AS id_origem_sk,
        *
    FROM origem
