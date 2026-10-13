SELECT a.account_id, a.account_number, a.account_type
FROM core.accounts a 
WHERE a.is_active = TRUE AND NOT EXISTS(SELECT 1 FROM core.transactions t WHERE a.account_id = t.account_id AND t.tx_type = 'DEPOSIT')
ORDER BY a.account_id;