{{ config(materialized='table') }}

WITH base AS (
    SELECT * FROM {{ ref('int_receitas_transfornadas') }}
),

classificacao_financeira AS (
    SELECT DISTINCT
        fonte_recurso_nome
    FROM base
)

SELECT
    ROW_NUMBER() OVER (ORDER BY fonte_recurso_nome) AS id_classificacao_sk,
    *
FROM classificacao_financeira
