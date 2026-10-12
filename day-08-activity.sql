-- Reporte 1 
SELECT account_number, account_type, balance 
FROM core.accounts 
WHERE balance >= 1000.00 OR account_type = 'SAVINGS'
ORDER BY balance DESC
LIMIT 2;

-- Reporte 2
SELECT first_name, last_name, email 
FROM core.customers 
WHERE email LIKE '%@email.com'

-- Reporte 3
-- La consulta deñ consultor falló por usar la condición description = NULL porque nunca va a considerarse en la consulta ya que toma el NULL
-- como si simplemente no existiera por lo que nunca va a devolver nada
SELECT account_id, tx_type, amount, COALESCE(description, 'COBRO INSTITUCIONAL O COMISION - SIN RECEPTOR') AS descripcion_visible
FROM core.transactions 
WHERE description IS NULL OR tx_type = 'WITHDRAWAL';