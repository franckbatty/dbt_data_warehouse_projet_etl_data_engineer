
-- ============================================================
-- MODÈLE : FACT_ORDERS
-- OBJECTIF : Construire la table de faits des commandes
-- SOURCES : STG_ORDERS et DIM_CUSTOMERS
-- CLÉ PRIMAIRE : ORDER_KEY (clé de substitution)
-- CLÉ ÉTRANGÈRE : CUSTOMER_KEY
-- ============================================================

WITH orders AS (

    -- Récupération des données nettoyées des commandes
    SELECT *
    FROM {{ ref('stg_orders') }}

),

customers AS (

    -- Récupération des clés clients depuis la dimension
    SELECT
        customer_key,
        identifiant_client
    FROM {{ ref('dim_customers') }}

),

final AS (

    -- Construction de la table de faits et calcul des montants
    SELECT
        ROW_NUMBER() OVER (ORDER BY o.identifiant_commande) AS order_key, -- Clé de substitution unique de la commande

        c.customer_key,             -- Clé étrangère vers DIM_CUSTOMERS

        o.identifiant_commande,     -- Identifiant métier de la commande
        o.identifiant_client,       -- Identifiant client provenant de la source
        o.date_commande,            -- Date de la commande
        o.produit,                  -- Produit commandé
        o.quantite,                 -- Quantité commandée
        o.prix_unitaire,            -- Prix unitaire du produit
        o.statut,                   -- Statut de la commande,
        -- Dates de traçabilité
        o.created_at,
        o.updated_at, 

        (o.quantite * o.prix_unitaire) AS montant_commande
        -- Calcul du montant total de la commande

    FROM orders o

    -- Association de chaque commande à son client
    INNER JOIN customers c
        ON o.identifiant_client = c.identifiant_client

)

-- Restitution de la table de faits
SELECT *
FROM final
