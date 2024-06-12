SELECT h.head, try.hierarchy_code, 
year(a.receipt_date), MONTH(a.receipt_date), SUM(a.amount) amt
FROM ctmis_accounts.ledger_receipts a 
JOIN probityfinancials.heads h 
	ON a.head_of_account = h.head_id
JOIN pfmaster.hierarchy_setup try 
	ON a.treasury = try.hierarchy_Id
	AND try.category = 'T'
WHERE 
date(a.receipt_date )BETWEEN DATE('2022-04-01') AND  DATE('2023-03-31')
#AND a.financial_year = '2022-23'
AND h.head LIKE '0030%'
GROUP BY h.head, try.hierarchy_code, MONTH(a.receipt_date),year(a.receipt_date)

ORDER BY 1,2,3,4