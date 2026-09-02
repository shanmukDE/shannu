select
    product_id::string as product_id,
    trim(product_name)::string as product_name,
    trim(category)::string as category,
    unit_cost::number(18,2) as unit_cost,
    updated_at::timestamp_tz as updated_at
from {{ source('raw_reference', 'products') }}
qualify row_number() over (partition by product_id order by updated_at desc) = 1

