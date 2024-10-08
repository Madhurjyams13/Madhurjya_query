SELECT year(b.voucher_date), MONTH(b.voucher_date),
ROUND ( SUM(b.total_allowance)/10000000 , 2) Amount_cr #month(b.voucher_date), 
FROM ctmis_accounts.ledger_expenditure le
LEFT JOIN probityfinancials.heads h 
		ON le.head_of_account = h.head_id
JOIN ctmis_master.bill_details_base b
	ON le.source_reference = b.id 
JOIN ctmis_dataset.bill_sub_type_master bt
	ON b.sub_type = bt.code
WHERE
DATE(b.voucher_date) BETWEEN '2021-04-01' AND '2024-07-31'
AND le.source_category = 'BILLS'
AND h.head NOT LIKE '2071-01-117-5962%'
AND ( SUBSTR(h.head,1,4) = '2071' OR b.bill_pension_type IS NOT NULL OR SUBSTR(h.head, 22,2)='21')
AND bt.name IN ( 'Monthly Pension Bill' , 'Pension Arrear')
GROUP BY year(b.voucher_date), MONTH(b.voucher_date)
ORDER BY 1,2