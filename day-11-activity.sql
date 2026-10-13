SELECT a.account_id, a.account_number, c.email, a.account_type, a.is_active, a.balance,
UPPER(CONCAT(c.first_name, c.last_name, '-', RIGHT(a.account_number, 4))) AS etiqueta
FROM core.accounts a
INNER JOIN core.customers c ON a.customer_id = c.customer_id
ORDER BY a.account_id ASC;

SELECT COUNT(*) AS total_cuentas
FROM core.accounts;

SELECT t.transaction_id, t.account_id, t.tx_type, t.amount AS importe,
t.tx_timestamp AS fecha_inicial,
t.tx_timestamp + INTERVAL '16 days' AS fecha_revision,
AGE(TIMESTAMPTZ '2026-10-01 00:00+00', t.tx_timestamp) AS antiguedad,
EXTRACT(MONTH FROM t.tx_timestamp) AS mes,
EXTRACT(YEAR FROM t.tx_timestamp) AS anio
FROM core.transactions t
WHERE t.tx_timestamp < TIMESTAMPTZ '2026-09-10 00:00+00'
ORDER BY t.tx_timestamp ASC, t.transaction_id ASC;

SELECT COUNT(*) AS total_transacciones
FROM core.transactions
WHERE tx_timestamp < TIMESTAMPTZ '2026-09-10 00:00+00';