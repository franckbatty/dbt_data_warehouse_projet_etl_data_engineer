
-- ============================================================
-- MODÈLE : STG_ORDERS
-- OBJECTIF : Nettoyer et standardiser les données des commandes
-- SOURCE : raw.orders
-- ============================================================

-- 1. Récupération des données depuis la source RAW
WITH source AS (

    SELECT *
    FROM {{ source('raw', 'orders') }}

),

-- 2. Nettoyage et standardisation des colonnes
renamed AS (

    SELECT

        -- Identifiant unique de la commande
        id_commande AS identifiant_commande,

        -- Identifiant du client ayant passé la commande
        id_client AS identifiant_client,

        -- Conversion du timestamp en millisecondes vers une date
        date_commande,

        -- Suppression des espaces inutiles dans le nom du produit
        TRIM(produit) AS produit,

        -- Quantité commandée
        quantite AS quantite,

        -- Prix unitaire du produit
        prix_unitaire AS prix_unitaire,

        -- Harmonisation du statut en minuscules
        LOWER(TRIM(statut)) AS statut

    FROM source

)

-- 3. Restitution des données nettoyées
SELECT *
FROM renamed
