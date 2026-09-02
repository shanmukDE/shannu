select *
from {{ ref('fct_orders') }}
where quantity <= 0 or unit_price < 0 or net_sales < 0

