SELECT YEAR(a.voucher_date),MONTH(a.voucher_date), 
case 
	when a.source_category = 'BILLS' then 'Salary'
	when a.source_category = 'MANUAL' then 'Cash Challan'
	ELSE 'Others'
	END AS ctype,
round(SUM(a.amount)/100000,2), round(SUM(a.amount)/10000000,2)
FROM ctmis_accounts.ledger_receipts a
JOIN probityfinancials.heads h
	ON a.head_of_account = h.head_id
WHERE
h.head LIKE '8011%'
AND DATE(a.voucher_date) BETWEEN '2023-04-01' AND '2024-03-31'
GROUP BY YEAR(a.voucher_date),MONTH(a.voucher_date), case 
	when a.source_category = 'BILLS' then 'Salary'
	when a.source_category = 'MANUAL' then 'Cash Challan'
	ELSE 'Others'
	END
ORDER BY 1,2,3