
-- ============================================================
-- MODÈLE : STG_CUSTOMERS
-- OBJECTIF : Nettoyer et standardiser les données des clients
-- SOURCE : raw.customers
-- ============================================================

-- 1. Récupération des données depuis la source RAW
WITH source AS (

    SELECT *
    FROM {{ source('raw', 'customers') }}

),

-- 2. Nettoyage et standardisation des colonnes
renamed AS (

    SELECT

        -- Renommage de l'identifiant client
        id_client AS identifiant_client,

        -- Suppression des espaces inutiles dans le prénom
        TRIM(prenom) AS prenom,

        -- Suppression des espaces inutiles dans le nom
        TRIM(nom) AS nom,

        -- Suppression des espaces et conversion de l'email en minuscules
        LOWER(TRIM(email)) AS email,

        -- Suppression des espaces inutiles dans la ville
        TRIM(ville) AS ville,

        -- Conversion du timestamp en millisecondes vers une date
        date_inscription

    FROM source

)

-- 3. Restitution des données nettoyées
SELECT *
FROM renamed
