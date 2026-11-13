
-- ============================================================
-- MODÈLE : DIM_DATE
-- OBJECTIF : Construire la dimension temporelle
-- PACKAGE : DBT_DATE
-- CLÉ MÉTIER : DATE_DAY
-- ============================================================

-- Génération automatique des attributs calendaires
-- Période : du 01 juillet au 21 juillet 2025
'''
{{ dbt_date.get_date_dimension(
    "2025-07-01",
    "2025-07-21"
) }}
'''

-- ============================================================
-- MODÈLE : DIM_DATE
-- OBJECTIF : Construire la dimension temporelle
-- PACKAGE : DBT_DATE
-- CLÉ PRIMAIRE : DATE_KEY
-- ============================================================

WITH date_dimension AS (

    -- Génération des dates et attributs calendaires
    {{ dbt_date.get_date_dimension(
        "2025-07-01",
        "2025-07-21"
    ) }}

),

final AS (

    -- Ajout de la clé de substitution
    SELECT
        TO_CHAR(date_day, 'YYYYMMDD')::INTEGER AS date_key,
        date_dimension.*

    FROM date_dimension

)

SELECT *
FROM final
