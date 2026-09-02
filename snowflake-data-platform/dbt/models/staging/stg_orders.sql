{{ config(materialized='incremental', unique_key='order_id', incremental_strategy='merge') }}

with ranked as (
    select
        order_id,
        customer_id,
        order_ts,
        status,
        currency,
        items,
        source_file,
        ingested_at,
        row_number() over (partition by order_id order by ingested_at desc) as row_num
    from {{ source('staging_source', 'orders_incremental') }}
    where order_id is not null
    {% if is_incremental() %}
      and ingested_at > (select coalesce(max(ingested_at), '1900-01-01') from {{ this }})
    {% endif %}
)
select * exclude row_num from ranked where row_num = 1

