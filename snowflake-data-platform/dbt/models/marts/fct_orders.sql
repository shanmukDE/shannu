{{ config(materialized='incremental', unique_key='order_line_sk', cluster_by=['order_date']) }}

select
    {{ dbt_utils.generate_surrogate_key(['i.order_id', 'i.item_sequence']) }} as order_line_sk,
    i.order_id,
    i.item_sequence,
    i.order_ts,
    to_date(i.order_ts) as order_date,
    c.customer_sk,
    p.product_sk,
    i.status,
    i.currency,
    i.quantity,
    i.unit_price,
    i.quantity * i.unit_price as net_sales,
    current_timestamp() as dbt_loaded_at
from {{ ref('stg_order_items') }} i
left join {{ ref('dim_customers') }} c
  on i.customer_id = c.customer_id
 and i.order_ts >= c.effective_from
 and i.order_ts < c.effective_to
left join {{ ref('dim_products') }} p on i.product_id = p.product_id
{% if is_incremental() %}
where i.order_ts >= dateadd(day, -3, (select coalesce(max(order_ts), '1900-01-01') from {{ this }}))
{% endif %}

