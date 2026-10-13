SELECT (SELECT COUNT(*) FROM core.customers) AS total_customers,
       (SELECT COUNT(*) FROM core.accounts) AS total_accounts,
       (SELECT COUNT(*) FROM core.transactions) AS total_transactions;
       SELECT COUNT(*) AS producto
       FROM core.customers CROSS JOIN core.accounts CROSS JOIN core.transactions;

SELECT c.email, a.account_number, t.tx_type, t.amount, t.tx_timestamp
FROM core.transactions t
JOIN core.accounts a ON a.account_id = t.account_id
JOIN core.customers c ON c.customer_id = a.customer_id
WHERE c.is_active = TRUE AND t.amount >= 100
ORDER BY t.tx_timestamp, t.transaction_id;