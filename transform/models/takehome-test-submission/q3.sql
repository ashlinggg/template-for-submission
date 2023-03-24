{{
    config(
        materialized='view'
    )
}}


WITH sub1 AS (
    SELECT 
        o.vendor_id, 
        v.country_name, 
        v.vendor_name, 
    
        SUM(o.gmv_local) AS total_gmv
    
    FROM `majestic-vault-381405`.Orders_Dataset.Orders_Table o
    
    JOIN `majestic-vault-381405`.Vendors_Dataset.Vendors_Table v 
        ON o.vendor_id = v.id
    
    GROUP BY o.vendor_id, v.country_name, v.vendor_name
),

sub2 AS (
    SELECT 
        o.vendor_id, 
        v.country_name, 
        
        SUM(o.gmv_local) AS total_gmv
   
    FROM `majestic-vault-381405`.Orders_Dataset.Orders_Table o
    
    JOIN `majestic-vault-381405`.Vendors_Dataset.Vendors_Table v 
        ON o.vendor_id = v.id
    
    GROUP BY o.vendor_id, v.country_name
),

sub3 AS (
    SELECT 
        country_name, 
        
        MAX(total_gmv) AS max_gmv
    
    FROM sub2
 
    GROUP BY country_name
),

top_active_vendor_by_gmv_country AS (
    SELECT 
        v.country_name, 
        v.vendor_name, 
        
        ROUND(total_gmv,2) as total_gmv

    FROM sub1 v

    JOIN sub3 t 
        ON v.country_name = t.country_name 
        AND v.total_gmv = t.max_gmv

    ORDER BY country_name ASC
)

SELECT * FROM top_active_vendor_by_gmv_country