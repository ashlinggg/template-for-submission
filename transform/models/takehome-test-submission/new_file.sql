{{
    config(
        materialized='view'
    )
}}


WITH top_country AS (
  
  SELECT 
    country_name, 
    total_gmv
    
    FROM {{ ref('total_gmv_by_country') }}
    
    ORDER BY total_gmv desc
    
    LIMIT 1
)

SELECT * FROM top_country;