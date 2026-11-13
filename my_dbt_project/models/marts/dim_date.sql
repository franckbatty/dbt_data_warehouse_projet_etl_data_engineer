
-- ============================================================
-- MODÈLE : DIM_DATE
-- OBJECTIF : Construire la dimension temporelle
-- PACKAGE : DBT_DATE
-- CLÉ PRIMAIRE : DATE_KEY
-- CLÉ MÉTIER : DATE_DAY
-- ============================================================

-- Génération automatique des attributs calendaires
-- Période : du 01 juillet au 21 juillet 2025

WITH date_dimension AS (

    {{ dbt_date.get_date_dimension(
        "2025-07-01",
        "2025-07-21"
    ) }}

),

final AS (

    -- Ajout de la clé de substitution
    SELECT
        TO_CHAR(date_day, 'YYYYMMDD')::INTEGER AS date_key,

        date_dimension.* -- Récupération de toutes les colonnes générées par la macro DBT_DATE

    FROM date_dimension

)

-- Restitution de la dimension temporelle
SELECT *
FROM final
