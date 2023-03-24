WITH top_countries AS (
  
  SELECT 
    country_name, 
    total_gmv,
    
    RANK() OVER (ORDER BY total_gmv DESC) as gmv_rank
  
  FROM {{ ref('total_gmv_by_country') }}
 
  WHERE total_gmv > 1000
)

SELECT 
  country_name, 
  total_gmv

FROM top_countries

WHERE gmv_rank <= 3