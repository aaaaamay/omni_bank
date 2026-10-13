SELECT t.transaction_id, t.account_id, t.tx_type, t.amount,
(SELECT ROUND(AVG(tx.amount), 2)
FROM core.transactions tx
WHERE tx.account_id = t.account_id ) AS promedio_cuenta 
FROM core.transactions t 
WHERE t.amount > (SELECT AVG(tx.amount) FROM core.transactions tx
WHERE tx.account_id = t.account_id)
ORDER BY t.transaction_id ASC; 

SELECT account_id, COUNT(transaction_id), ROUND(AVG(amount), 2)
FROM core.transactions 
GROUP BY account_id
ORDER BY account_id ASC;

SELECT a.account_id, a.account_number, a.account_type, a.balance, a.is_active
FROM core.accounts a
WHERE NOT EXISTS (SELECT 1 FROM core.transactions t WHERE t.account_id = a.account_id)
ORDER BY a.account_id ASC;