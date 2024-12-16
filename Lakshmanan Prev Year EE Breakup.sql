SELECT m.yr, m.mon, m.mhead, m.dhead, SUM(amt) FROM 
(

SELECT YEAR(le.expenditure_date) yr, MONTH(le.expenditure_date) mon,
CONCAT( mh.head_code, '->', mh.head_name) mhead,
CONCAT( dh.head_code, '->', dh.head_name) dhead,
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'EE'
END AS scheme,
ROUND ( SUM(b.total_allowance)/10000000 , 2) amt
FROM ctmis_accounts.ledger_expenditure le
LEFT JOIN probityfinancials.heads h 
		ON le.head_of_account = h.head_id
LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
	ON	h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc 
	ON	pchm.pc_id = pc.pc_id
JOIN ctmis_master.bill_details_base b
	ON le.source_reference = b.id 
JOIN probityfinancials.head_setup mh 
	ON h.major_head = mh.head_setup_id
JOIN probityfinancials.head_setup dh 
	ON h.detailed_head = dh.head_setup_id
WHERE
date(le.expenditure_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
AND le.financial_year = '2023-24'
AND le.source_category = 'BILLS'
AND SUBSTR(h.head,1,4) <> '2071' AND  b.bill_pension_type IS NULL
AND SUBSTR(h.head, 22,2) NOT IN ('01','02','31','21')
GROUP BY 
CONCAT( mh.head_code, '->', mh.head_name) ,
CONCAT( dh.head_code, '->', dh.head_name) ,
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'EE'
END, YEAR(le.expenditure_date), MONTH(le.expenditure_date)

UNION ALL  


SELECT YEAR(le.expenditure_date), MONTH(le.expenditure_date),
CONCAT( mh.head_code, '->', mh.head_name) mhead,
CONCAT( dh.head_code, '->', dh.head_name) dhead,
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
JOIN probityfinancials.head_setup mh 
	ON h.major_head = mh.head_setup_id
JOIN probityfinancials.head_setup dh 
	ON h.detailed_head = dh.head_setup_id
WHERE
le.source_category = 'CHEQUE'
AND date(le.expenditure_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
AND le.financial_year = '2023-24'
AND h.head NOT LIKE '8443-00-120%'
GROUP BY
CONCAT( mh.head_code, '->', mh.head_name) ,
CONCAT( dh.head_code, '->', dh.head_name) , 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'EE'
END ,YEAR(le.expenditure_date), MONTH(le.expenditure_date)

) m

WHERE m.scheme = 'EE'

GROUP BY m.yr, m.mon, m.mhead, m.dhead
ORDER BY 1,2,3,4