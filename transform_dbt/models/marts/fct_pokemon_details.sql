SELECT
    p.pokemon_id,
    p.pokemon_name,
    p.primary_type,
    p.height_m,
    p.weight_kg,
    p.base_experience,
    s.xp_category,
    -- métricas contextuales del tipo de Pokémon al que pertenece
    t.total_pokemons AS pokemons_in_same_type,
    t.avg_weight_kg AS avg_type_weight_kg,
    
    CASE 
        WHEN p.weight_kg > t.avg_weight_kg THEN 'Above Type Average'
        ELSE 'Below or Equal to Type Average'
    END AS weight_comparison_to_type
FROM {{ ref('stg_pokemons') }} p
INNER JOIN {{ ref('stg_pokemon_stats') }} s 
    ON p.pokemon_id = s.pokemon_id
INNER JOIN {{ ref('dim_pokemon_summary') }} t 
    ON p.primary_type = t.primary_type