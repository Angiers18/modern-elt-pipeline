WITH

type_aggregates AS (
    SELECT
        primary_type,
        COUNT(pokemon_id) AS total_pokemons,
        ROUND(AVG(height_m), 2) AS avg_height_m,
        ROUND(AVG(weight_kg), 2) AS avg_weight_kg,
        ROUND(AVG(base_experience), 1) AS avg_base_experience,
        MAX(weight_kg) AS max_weight_kg,
        MIN(weight_kg) AS min_weight_kg
    FROM {{ ref('stg_pokemons') }}
    GROUP BY primary_type
)

SELECT
    primary_type,
    total_pokemons,
    avg_height_m,
    avg_weight_kg,
    avg_base_experience,
    max_weight_kg,
    min_weight_kg,
    -- Clasificamos qué tipo es el más pesado en promedio
    RANK() OVER (ORDER BY avg_weight_kg DESC) as weight_rank_by_type
FROM type_aggregates
ORDER BY total_pokemons DESC