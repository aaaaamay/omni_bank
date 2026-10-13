SELECT t.transaction_id AS primer_id, tx.transaction_id AS segundo_id, t.account_id 
FROM core.transactions t JOIN core.transactions tx ON t.account_id = tx.account_id 
AND (t.tx_timestamp, t.transaction_id) < (tx.tx_timestamp, tx.transaction_id)
AND tx.tx_timestamp <= t.tx_timestamp + INTERVAL '48 hours'
ORDER BY t.account_id, t.tx_timestamp;

WITH tipos_cuentas AS (SELECT unnest(enum_range(NULL::core.tipo_cuenta)) AS account_type)

SELECT c.customer_id, c.first_name, c.last_name, c.email, tc.account_type
FROM core.customers c CROSS JOIN tipos_cuentas tc
LEFT JOIN core.accounts a ON c.customer_id = a.customer_id AND a.account_type = tc.account_type 
WHERE NOT EXISTS(SELECT 1 FROM core.accounts a WHERE a.customer_id = c.customer_id AND a.account_type = tc.account_type)
ORDER BY c.email, tc.account_type;