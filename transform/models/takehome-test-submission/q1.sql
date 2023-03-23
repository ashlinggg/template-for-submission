{{
    config(
        materialized='view'
    )
}}


WITH total_gmv_by_country AS (
    
    SELECT
        country_name, 
      
        ROUND(SUM(gmv_local),2) AS total_gmv 

    FROM `majestic-vault-381405`.Orders_Dataset.Orders_Table

    GROUP BY country_name
)

SELECT * FROM total_gmv_by_country