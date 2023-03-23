{{
    config(
        materialized='view'
    )
}}


WITH q1 AS (
    
    SELECT
      country_name, 
      
      ROUND(SUM(gmv_local),2) AS total_gmv 

    FROM `majestic-vault-381405`.Orders_Dataset.Orders_Table

    GROUP BY country_name
)

SELECT * FROM q1