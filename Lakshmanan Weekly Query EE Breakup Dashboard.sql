#EE BREAKUP
SELECT m.* FROM 
(
	SELECT 
	CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
	END AS Scheme,
	CONCAT( mh.head_code, '->', mh.head_name) mhead,
	CONCAT( dh.head_code, '->', dh.head_name) dhead,
	date(le.expenditure_date) dd,
	ROUND ( SUM(b.total_allowance)/10000000 , 2)Amount
	FROM ctmis_accounts.ledger_expenditure le
	LEFT JOIN probityfinancials.heads h 
			ON le.head_of_account = h.head_id
	LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
		ON	h.head_id = pchm.head_id
	LEFT JOIN probityfinancials.plan_category pc 
		ON	pchm.pc_id = pc.pc_id
	JOIN ctmis_master.bill_details_base b
		ON le.source_reference = b.id 
	JOIN probityfinancials.head_setup dh 
		ON h.detailed_head = dh.head_setup_id
	JOIN probityfinancials.head_setup mh 
		ON h.major_head = mh.head_setup_id
	WHERE
	date(le.expenditure_date) BETWEEN DATE('2024-04-01') AND DATE(NOW())
	AND le.financial_year = '2024-25'
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
	CONCAT( dh.head_code, '->', dh.head_name),
	CONCAT( mh.head_code, '->', mh.head_name),
	date(le.expenditure_date)
) m	
WHERE
m.scheme = 'EE'
ORDER BY 3,2