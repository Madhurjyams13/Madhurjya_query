SELECT m.scheme, SUM(m.amt) FROM 
(

SELECT 'Salary' scheme, ROUND ( SUM(le.amount)/10000000 , 2) amt
FROM ctmis_accounts.ledger_expenditure le
LEFT JOIN probityfinancials.heads h 
		ON le.head_of_account = h.head_id
#JOIN ctmis_master.bill_details_base b
#	ON le.source_reference = b.id 
WHERE
date(le.expenditure_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
AND le.financial_year = '2023-24'
AND le.source_category = 'BILLS'
AND SUBSTR(h.head, 22,2) IN ('01','02','31')
#AND SUBSTR(h.head, 22,5) = '01'

UNION ALL 

SELECT 'Pension', ROUND ( SUM(b.total_allowance)/10000000 , 2)
FROM ctmis_accounts.ledger_expenditure le
LEFT JOIN probityfinancials.heads h 
		ON le.head_of_account = h.head_id
JOIN ctmis_master.bill_details_base b
	ON le.source_reference = b.id 
WHERE
DATE(b.voucher_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
AND le.financial_year = '2023-24'
AND le.source_category = 'BILLS'
AND ( SUBSTR(h.head,1,4) = '2071' OR b.bill_pension_type IS NOT NULL OR SUBSTR(h.head, 22,2) = '21' )

UNION ALL 

SELECT 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'EE'
END AS scheme,
ROUND ( SUM(b.total_allowance)/10000000 , 2)
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
date(le.expenditure_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
AND le.financial_year = '2023-24'
AND le.source_category = 'BILLS'
AND SUBSTR(h.head,1,4) <> '2071' AND  b.bill_pension_type IS NULL
AND SUBSTR(h.head, 22,2) NOT IN ('01','02','31', '21')
#AND SUBSTR(h.head,1,4) NOT IN ('8342','8550','8658')
GROUP BY 
h.head,
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'EE'
END


UNION ALL 

SELECT 'Sixth Schedule' scheme, ROUND ( SUM(le.amount)/10000000 , 2)
FROM ctmis_accounts.ledger_expenditure le 
LEFT JOIN probityfinancials.heads h
	ON le.head_of_account = h.head_id
WHERE
le.source_category = 'CHEQUE'
AND date(le.expenditure_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
AND le.financial_year = '2023-24'
AND h.head LIKE '8443-00-120%'


UNION ALL 


SELECT 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'EE'
END AS scheme, ROUND ( SUM(le.amount)/10000000 , 2)
FROM ctmis_accounts.ledger_expenditure le 
LEFT JOIN probityfinancials.heads h
	ON le.head_of_account = h.head_id
LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
	ON	h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc 
	ON	pchm.pc_id = pc.pc_id
WHERE
le.source_category = 'CHEQUE'
AND date(le.expenditure_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
AND le.financial_year = '2023-24'
AND h.head NOT LIKE '8443-00-120%'
GROUP BY 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'EE'
END 

) m 
GROUP BY m.scheme

