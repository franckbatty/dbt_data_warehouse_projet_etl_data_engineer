
-- ============================================================
-- MODÈLE : FACT_ORDERS
-- OBJECTIF : Construire la table de faits des commandes
-- SOURCES : STG_ORDERS, DIM_CUSTOMERS et DIM_DATE
-- CLÉ PRIMAIRE : ORDER_KEY
-- CLÉS ÉTRANGÈRES : CUSTOMER_KEY et DATE_KEY
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

dates AS (

    -- Récupération des clés de la dimension temporelle
    SELECT
        date_key,
        date_day
    FROM {{ ref('dim_date') }}

),

final AS (

    -- Construction de la table de faits
    SELECT
        ROW_NUMBER() OVER (
            ORDER BY o.identifiant_commande
        ) AS order_key,

        c.customer_key, -- Clé étrangère vers DIM_CUSTOMERS
        d.date_key,     -- Clé étrangère vers DIM_DATE

        o.identifiant_commande,
        o.identifiant_client,
        o.date_commande,
        o.produit,
        o.quantite,
        o.prix_unitaire,
        o.statut,

        o.created_at,
        o.updated_at,

        -- Calcul du montant total de la commande
        (o.quantite * o.prix_unitaire) AS montant_commande

    FROM orders o

    -- Association de chaque commande à son client
    INNER JOIN customers c
        ON o.identifiant_client = c.identifiant_client

    -- Association de chaque commande à sa date
    INNER JOIN dates d
        ON o.date_commande = d.date_day

)

-- Restitution de la table de faits
SELECT *
FROM final
