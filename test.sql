SELECT
case
	when MONTH(a.receipt_date)>=4
      then concat(YEAR(a.receipt_date), '-',YEAR(a.receipt_date)+1)
   else 
		concat(YEAR(a.receipt_date)-1,'-', YEAR(a.receipt_date)) 
END AS fy, 
SUM(a.amount) # a.* 
FROM ctmis_accounts.ledger_receipts a
JOIN probityfinancials.heads h
	ON a.head_of_account = h.head_id
WHERE
h.head LIKE '8342-00-117-0002%'
AND date(a.receipt_date) BETWEEN '2008-04-01' AND '2024-03-31'
GROUP BY 
case
	when MONTH(a.receipt_date)>=4
      then concat(YEAR(a.receipt_date), '-',YEAR(a.receipt_date)+1)
   else 
		concat(YEAR(a.receipt_date)-1,'-', YEAR(a.receipt_date)) END 
ORDER BY 1
#LIMIT 0,20