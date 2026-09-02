select
    o.order_id,
    o.customer_id,
    o.order_ts,
    o.status,
    o.currency,
    i.value:product_id::string as product_id,
    i.value:quantity::number as quantity,
    i.value:unit_price::number(18,2) as unit_price,
    i.index::number as item_sequence
from {{ ref('stg_orders') }} o,
lateral flatten(input => o.items) i

