
-- ============================================================
-- MODÈLE : DIM_DATE
-- OBJECTIF : Construire la dimension temporelle
-- PACKAGE : DBT_DATE
-- CLÉ MÉTIER : DATE_DAY
-- ============================================================

-- Génération automatique des attributs calendaires
-- Période : du 01 juillet au 21 juillet 2025

{{ dbt_date.get_date_dimension(
    "2025-07-01",
    "2025-07-21"
) }}
