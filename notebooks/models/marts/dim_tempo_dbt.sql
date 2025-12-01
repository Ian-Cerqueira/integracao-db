{{ config(materialized='table') }}

WITH base AS (
    SELECT * FROM {{ ref('int_receitas_transfornadas') }}
),


tempo AS (
    SELECT DISTINCT
        ano,
        mes
    FROM base
)

SELECT
    ROW_NUMBER() OVER (ORDER BY ano, mes) AS id_tempo_sk,
    *
FROM tempo