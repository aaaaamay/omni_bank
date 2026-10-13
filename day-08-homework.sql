SELECT transaction_id, account_id, tx_type, amount
FROM core.transactions 
WHERE (amount > 10000.00 AND tx_type IN ('TRANSFER', 'WITHDRAWAL')) 
   OR (description ILIKE '%CRYPTO%')
   OR (description ILIKE '%offshore%')
   OR (description ILIKE '%shell%')
   OR (description ILIKE '%casino%')
   OR (description IS NULL AND tx_type != 'DEPOSIT');

SELECT transaction_id, amount, tx_type, tx_timestamp, 
COALESCE(description, 'EXCLUSION OPORTUNAMENTE DETECTADA - SIN MOTIVO DE PAGO') AS descripcion_monitoreada 
FROM core.transactions 
WHERE (amount > 10000.00 AND tx_type IN ('TRANSFER', 'WITHDRAWAL')) 
   OR (NULLIF(TRIM(description), '') IS NULL AND tx_type != 'DEPOSIT')
ORDER BY amount DESC;

-- La jerarquía operativa falló por falta de los paréntesis ya que se fragmentó la lógica en dos grandes bloques unidos por un OR