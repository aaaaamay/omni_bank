WITH movimientos AS (SELECT account_id, COUNT(*) AS eventos, SUM(amount) AS volumen_bruto
FROM core.transactions
GROUP BY account_id),
cuentas_activas AS (SELECT a.account_id, a.account_number, a.currency, a.customer_id,
COALESCE(m.eventos, 0) AS eventos, 
COALESCE(m.volumen_bruto, 0) AS volumen_bruto
FROM core.accounts a LEFT JOIN movimientos m USING (account_id)
WHERE a.is_active)
SELECT c.first_name, c.last_name, ca.account_number, ca.currency, ca.eventos, ca.volumen_bruto,
CASE WHEN ca.eventos = 0 
	THEN 'SIN MOVIMIENTOS' 
	ELSE 'CON MOVIMIENTOS' 
	END AS banda_actividad 
FROM cuentas_activas ca JOIN core.customers c USING (customer_id)
ORDER BY ca.account_number;

SELECT (SELECT COUNT(*) FROM core.accounts WHERE is_active) AS cuentas_activas,
       (SELECT COALESCE(SUM(amount),0) FROM core.transactions) AS volumen_bruto;