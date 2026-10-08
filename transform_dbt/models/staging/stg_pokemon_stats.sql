SELECT
    id AS pokemon_id,
    LOWER(name) AS pokemon_name,
    base_experience,
    -- Agregamos un indicador calculado de categoría de experiencia
    CASE 
        WHEN base_experience < 60 THEN 'Low XP'
        WHEN base_experience BETWEEN 60 AND 150 THEN 'Medium XP'
        ELSE 'High XP'
    END AS xp_category
FROM {{ source('raw_data', 'raw_pokemons') }}