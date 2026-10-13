WITH movimientos AS (SELECT account_id, SUM(amount) AS volumen_bruto
FROM core.transactions
GROUP BY account_id),

cuentas_activas AS (SELECT a.account_id, a.account_number, a.currency,
COALESCE(m.volumen_bruto, 0) AS volumen_bruto
FROM core.accounts a LEFT JOIN movimientos m USING (account_id)
WHERE a.is_active),

divisa AS (SELECT currency, COUNT(*) AS numero_cuentas, SUM(volumen_bruto) AS volumen_bruto
FROM cuentas_activas 
GROUP BY currency)

SELECT currency, numero_cuentas, volumen_bruto, ROUND(volumen_bruto / numero_cuentas, 2) AS promedio
FROM divisa 
ORDER BY currency;

SELECT(SELECT COUNT(*) FROM core.accounts WHERE is_active) AS cuentas_activas,
(SELECT COALESCE(SUM(amount), 0) FROM core.transactions) AS volumen_bruto,
(SELECT COUNT(*) FROM core.transactions t JOIN core.accounts a USING(account_id)
WHERE a.account_number='ACCT-3002') AS cuenta_sin_eventos;