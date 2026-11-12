
-- ============================================================
-- MODÈLE : DIM_CUSTOMERS
-- OBJECTIF : Construire la dimension des clients
-- SOURCE : STG_CUSTOMERS
-- CLÉ PRIMAIRE : CUSTOMER_KEY (clé de substitution)
-- CLÉ MÉTIER : IDENTIFIANT_CLIENT
-- ============================================================

WITH customers AS (

    -- Récupération des données nettoyées depuis la couche Staging
    SELECT *
    FROM {{ ref('stg_customers') }}

),

final AS (

    -- Création de la clé de substitution et sélection des attributs clients
    SELECT
        ROW_NUMBER() OVER (ORDER BY identifiant_client) AS customer_key, -- Clé technique unique générée par dbt

        identifiant_client, -- Identifiant provenant du système source
        prenom,             -- Prénom du client
        nom,                -- Nom du client
        email,              -- Adresse électronique du client
        ville,              -- Ville de résidence du client
        date_inscription    -- Date d'inscription du client

    FROM customers

)

-- Restitution de la dimension des clients
SELECT *
FROM final
