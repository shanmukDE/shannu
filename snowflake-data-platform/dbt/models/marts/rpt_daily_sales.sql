select
    order_date,
    product_sk as product_id,
    sum(quantity) as quantity,
    sum(net_sales) as net_sales,
    count(distinct order_id) as order_count
from {{ ref('fct_orders') }}
where status not in ('CANCELLED', 'REFUNDED')
group by 1, 2

