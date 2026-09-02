{{ config(materialized='incremental', unique_key='customer_sk', incremental_strategy='merge') }}

with source_rows as (
    select
        {{ dbt_utils.generate_surrogate_key(['customer_id', 'updated_at']) }} as customer_sk,
        customer_id,
        customer_name,
        email,
        state,
        updated_at as effective_from,
        lead(updated_at) over (partition by customer_id order by updated_at) as next_effective_from
    from {{ ref('stg_customers') }}
)
select
    customer_sk,
    customer_id,
    customer_name,
    email,
    state,
    effective_from,
    coalesce(dateadd(millisecond, -1, next_effective_from), '9999-12-31'::timestamp_tz) as effective_to,
    next_effective_from is null as is_current
from source_rows

