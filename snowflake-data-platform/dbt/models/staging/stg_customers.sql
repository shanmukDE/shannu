select
    customer_id::string as customer_id,
    trim(customer_name)::string as customer_name,
    lower(trim(email))::string as email,
    upper(trim(state))::string as state,
    updated_at::timestamp_tz as updated_at
from {{ source('raw_reference', 'customers') }}
qualify row_number() over (partition by customer_id order by updated_at desc) = 1

