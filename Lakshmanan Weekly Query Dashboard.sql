SELECT CONCAT('Salary -> ',SUBSTR(h.head, 22,2)) Particulars, 
ROUND ( SUM(le.amount)/10000000 , 2) Amount_cr, date(le.expenditure_date)
FROM ctmis_accounts.ledger_expenditure le
LEFT JOIN probityfinancials.heads h 
		ON le.head_of_account = h.head_id
#JOIN ctmis_master.bill_details_base b
#	ON le.source_reference = b.id 
WHERE
date(le.expenditure_date) BETWEEN DATE('2024-04-01') AND DATE(NOW())
AND le.source_category = 'BILLS'
AND SUBSTR(h.head, 22,2) IN ('01','02','31')
#AND SUBSTR(h.head, 22,5) = '01'
GROUP BY date(le.expenditure_date), CONCAT('Salary -> ',SUBSTR(h.head, 22,2))

UNION ALL 

SELECT 'Pension', ROUND ( SUM(b.total_allowance)/10000000 , 2) Amount_cr, date(b.voucher_date) 
FROM ctmis_accounts.ledger_expenditure le
LEFT JOIN probityfinancials.heads h 
		ON le.head_of_account = h.head_id
JOIN ctmis_master.bill_details_base b
	ON le.source_reference = b.id 
WHERE
date(b.voucher_date)  BETWEEN DATE('2024-04-01') AND DATE(NOW())
AND le.source_category = 'BILLS'
AND b.head_id NOT IN (69212,86597,43872)
AND ( SUBSTR(h.head,1,4) = '2071' OR b.bill_pension_type IS NOT NULL OR SUBSTR(h.head, 22,2)='21')
GROUP BY date(b.voucher_date) 

UNION ALL 

SELECT 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'EE'
END AS scheme,
ROUND ( SUM(b.total_allowance)/10000000 , 2) Amount_cr, date(le.expenditure_date)
FROM ctmis_accounts.ledger_expenditure le
LEFT JOIN probityfinancials.heads h 
		ON le.head_of_account = h.head_id
LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
	ON	h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc 
	ON	pchm.pc_id = pc.pc_id
JOIN ctmis_master.bill_details_base b
	ON le.source_reference = b.id 
WHERE
date(le.expenditure_date) BETWEEN DATE('2024-04-01') AND DATE(NOW())
AND le.source_category = 'BILLS'
AND b.head_id NOT IN (69212,86597,43872)
AND SUBSTR(h.head,1,4) <> '2071' AND  b.bill_pension_type IS NULL
AND SUBSTR(h.head, 22,2) NOT IN ('01','02','31','21')
GROUP BY 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'EE'
END,
date(le.expenditure_date)

UNION ALL 

SELECT 'Sixth Schedule', ROUND ( SUM(le.amount)/10000000 , 2) Amount_cr, date(le.expenditure_date)
FROM ctmis_accounts.ledger_expenditure le
LEFT JOIN ctmis_master.pay_cheque_base b
		ON le.source_reference = b.id 
		AND le.source_category = 'CHEQUE'
LEFT JOIN probityfinancials.heads h 
		ON le.head_of_account = h.head_id
WHERE
date(le.expenditure_date) BETWEEN DATE('2024-04-01') AND DATE(NOW())
AND le.source_category <> 'BILLS'
GROUP BY date(le.expenditure_date)

UNION ALL 

SELECT
case 
	when b.head_id = 69212 then 'NPS Employee Contribution'
	when b.head_id = 86597 then 'NPS Government Contribution'
END AS scheme,
ROUND ( SUM(le.amount)/10000000 , 2) Amount_cr, date(le.expenditure_date) 
FROM ctmis_accounts.ledger_expenditure le
JOIN ctmis_master.bill_details_base b
	ON le.source_reference = b.id
WHERE 
date(le.expenditure_date) BETWEEN DATE('2024-04-01') AND DATE(NOW())
AND le.source_category = 'BILLS'
AND b.head_id IN (69212,86597)
GROUP BY case 
	when b.head_id = 69212 then 'NPS Employee Contribution'
	when b.head_id = 86597 then 'NPS Government Contribution'
END, date(le.expenditure_date)
