{{ config(materialized='table') }}

WITH base AS (
    SELECT * FROM {{ ref('int_receitas_transfornadas') }}
),


entidades AS (
    SELECT DISTINCT
        orgao_nome,
        unidade_nome
    FROM base
)

SELECT
    ROW_NUMBER() OVER (ORDER BY orgao_nome, unidade_nome) AS id_entidade_sk,
    *
FROM entidades