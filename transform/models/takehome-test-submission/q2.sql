{{
    config(
        materialized='view'
    )
}}


WITH vendor_customer_gmv AS (
    
    SELECT
        vendor_name, 
      
        COUNT(customer_id) AS customer_count, 
        SUM(gmv_local) AS total_gmv

    FROM `majestic-vault-381405`.Orders_Dataset.Orders_Table o

    JOIN `majestic-vault-381405`.Vendors_Dataset.Vendors_Table v 
        ON o.vendor_id = v.id
    
    WHERE v.country_name = 'Taiwan'
    
    GROUP BY vendor_name
    
    ORDER BY customer_count DESC
)

SELECT * FROM vendor_customer_gmv