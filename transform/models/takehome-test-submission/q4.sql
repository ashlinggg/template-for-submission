{{
    config(
        materialized='view'
    )
}}


WITH yearly_vendor_gmv AS (
    SELECT
    
        EXTRACT(YEAR FROM o.date_local) AS year,
    
        v.country_name,
        v.vendor_name,
    
        ROUND(SUM(o.gmv_local), 2) AS total_gmv
  
    FROM `majestic-vault-381405.Orders_Dataset.Orders_Table` o
  
    JOIN `majestic-vault-381405.Vendors_Dataset.Vendors_Table` v
        ON o.vendor_id = v.id
  
    GROUP BY v.country_name, v.vendor_name, year
), 

ranked_vendor_gmv AS (
    SELECT
        year,
        country_name,
        vendor_name,
        total_gmv,
    
        ROW_NUMBER() OVER (
            PARTITION BY country_name, year
            ORDER BY total_gmv DESC
        ) AS vendor_rank
  
    FROM yearly_vendor_gmv
)

SELECT
    
    CONCAT(CAST(year AS STRING), "-01-01T00:00:00") AS year,
  
    country_name,
    vendor_name,
    total_gmv
    
    FROM ranked_vendor_gmv

    WHERE vendor_rank <= 2

    ORDER BY year, country_name, vendor_rank;