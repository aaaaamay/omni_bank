SELECT account_type, COUNT(account_type) AS account_ammount, SUM(balance) AS total_balance, MIN(balance) AS min_balance,
MAX(balance) AS max_balance, ROUND(AVG(balance), 2)
FROM core.accounts 
WHERE is_active = 'TRUE'
GROUP BY account_type
ORDER BY total_balance DESC, account_type ASC;

SELECT COUNT(account_type) AS active_accounts, SUM(balance) AS total_balance_accounts 
FROM core.accounts
WHERE is_active = TRUE; 

SELECT c.customer_id, c.first_name, c.last_name, c.email,
COUNT(t.transaction_id) AS total_transactions, 
COALESCE(SUM(t.amount), 0) AS recorded_gross_volume
FROM core.customers c
LEFT JOIN core.accounts a ON c.customer_id = a.customer_id
LEFT JOIN core.transactions t ON a.account_id = t.account_id
GROUP BY c.customer_id
HAVING COUNT(t.transaction_id) >= 2 OR COALESCE(SUM(t.amount), 0) > 100.00
ORDER BY recorded_gross_volume DESC, c.email ASC;

SELECT COUNT(transaction_id) AS total_transactions, SUM(amount) AS recorded_gross_volume 
FROM core.transactions; 