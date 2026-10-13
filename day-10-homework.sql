With muestra(valor) AS (VALUES (1000::NUMERIC), (0::NUMERIC), (0::NUMERIC), (NULL::NUMERIC))
SELECT ROUND(AVG(valor), 2) AS promedio, COUNT(valor) AS cantidad_valores, -- solo los 3 primeros valores con números
ROUND(AVG(COALESCE(valor, 0)), 2) AS promedio_total, COUNT(*) AS valores_totales -- todos los valores incluyendo el NULL
FROM muestra;

SELECT a.account_id, a.account_number, a.account_type, a.balance AS saldo_almacenado, a.is_active, 
COUNT(t.transaction_id) AS numero_movimientos, COALESCE(SUM(t.amount), 0) AS volumen_bruto 
FROM core.accounts a 
LEFT JOIN core.transactions t ON a.account_id = t.account_id 
WHERE a.account_type = 'CREDIT' AND a.is_active = 'TRUE'
GROUP BY a.account_id, a.account_number, a.account_type, a.balance, a.is_active 
HAVING COUNT(t.transaction_id) = 0 OR COALESCE(SUM(t.amount), 0) >= 300
ORDER BY a.account_number ASC;