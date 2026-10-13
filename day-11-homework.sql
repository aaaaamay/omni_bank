SELECT COUNT(*) AS cuentas_totales, 
COUNT(*) FILTER (WHERE is_active = FALSE) AS cuentas_desactivadas,
ROUND(COUNT(*) FILTER (WHERE is_active = FALSE)::NUMERIC / COUNT(*)::NUMERIC * 100, 2) AS porcentaje_desactivadas
FROM core.accounts; 

SELECT t.transaction_id, UPPER(CONCAT(c.first_name, ' ', c.last_name, '-', RIGHT(a.account_number, 4))) AS cuenta,
t.tx_timestamp AS fecha_inicial,
t.tx_timestamp + INTERVAL '15 days' AS fecha_revision,
AGE(TIMESTAMPTZ '2026-10-01 00:00+00', t.tx_timestamp) AS antiguedad 
FROM core.transactions t
JOIN core.accounts a ON a.account_id = t.account_id
JOIN core.customers c ON c.customer_id = a.customer_id
WHERE t.tx_timestamp < TIMESTAMPTZ '2026-09-10 00:00+00' 
ORDER BY t.tx_timestamp;