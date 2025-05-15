SELECT 
'Others',
dep.hierarchy_Name,
CASE 
	    WHEN CAST(mh.head_code AS INTEGER) >= 2000 AND CAST(mh.head_code AS INTEGER) < 4000 THEN 'Revenue'
	    WHEN CAST(mh.head_code AS INTEGER) >= 4000 AND CAST(mh.head_code AS INTEGER) < 6000 THEN 'Capital'
	    WHEN CAST(mh.head_code AS INTEGER) >= 6000 AND CAST(mh.head_code AS INTEGER) < 8000 THEN 'Loan And Advances'
	    WHEN CAST(mh.head_code AS INTEGER) > 8000 THEN 'Public Head'
	    ELSE 'Below Major Head 2000'
END AS exp_type,
CONCAT(mh.head_code, ' -> ' ,mh.head_name),
CONCAT(dh.head_code, ' -> ' ,dh.head_name),
case 
	when h.plan_status_migration IS NOT NULL  
		then h.plan_status_migration
	when pc.abbreviation IS NOT NULL 
		then pc.abbreviation
	ELSE 'EE'
END AS scheme, h.ga_ssa_status, h.voted_charged_status,
le.expenditure_date,
SUM(b.total_net_amount) "Amount"
FROM ctmis_accounts.ledger_expenditure_source_summary le
LEFT JOIN ctmis_master.bill_details_base b
	ON le.source_reference = b.id
	AND le.financial_year = b.financial_year
JOIN probityfinancials.heads h
	ON b.head_id = h.head_id
LEFT JOIN pfmaster.hierarchy_setup dep
	ON b.department_id = dep.hierarchy_Id
	AND dep.category = 'D'
JOIN probityfinancials.head_setup dh
	ON h.detailed_head = dh.head_setup_id
JOIN probityfinancials.head_setup mh
	ON h.major_head = mh.head_setup_id
LEFT JOIN probityfinancials.plan_category_head_mapping pchm
	ON h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc 
	ON pchm.pc_id = pc.pc_id
WHERE
le.financial_year = '2025-26'
AND le.expenditure_date BETWEEN '2025-04-01' AND '2025-04-30' 
AND le.source_payment_information_id IS NOT NULL
AND le.id NOT IN 

(	
	
	SELECT le.id
	FROM ctmis_accounts.ledger_expenditure_source_summary le
	LEFT JOIN ctmis_master.bill_details_base b ON le.source_reference = b.id AND le.financial_year = b.financial_year
	JOIN probityfinancials.heads h ON b.head_id = h.head_id
	LEFT JOIN probityfinancials.head_setup dh ON h.detailed_head = dh.head_setup_id
	JOIN probityfinancials.head_setup mh ON h.major_head = mh.head_setup_id
	WHERE le.financial_year = '2025-26'
	AND le.expenditure_date BETWEEN '2025-04-01' AND '2025-04-30'
	AND le.source_payment_information_id IS NOT NULL
	AND (
	    (SUBSTR(h.head,22,2) IN ('01','02','31') AND b.foc_number IS NULL AND CAST(mh.head_code AS INTEGER) < 8000) -- Salary
	 OR (SUBSTR(h.head,22,2) NOT IN ('01','02','31','21') AND b.foc_number IS NULL AND b.head_id NOT IN (86597) AND CAST(mh.head_code AS INTEGER) < 8000) -- Non-FoC
	 OR (b.foc_number IS NOT NULL AND CAST(mh.head_code AS INTEGER) < 8000) -- FoC
	 OR ((dh.head_code IN ('21') OR b.head_id IN (86597) OR mh.head_code = '2071') AND dh.head_code NOT IN ('01','02','31')) -- Pension
	 OR (CAST(mh.head_code AS INTEGER) > 8000 AND dh.head_code NOT IN ('01','02','31','21') AND b.head_id NOT IN (86597)) -- Public Account
		)
		
)
GROUP BY dep.hierarchy_Name,
CASE 
	    WHEN CAST(mh.head_code AS INTEGER) >= 2000 AND CAST(mh.head_code AS INTEGER) < 4000 THEN 'Revenue'
	    WHEN CAST(mh.head_code AS INTEGER) >= 4000 AND CAST(mh.head_code AS INTEGER) < 6000 THEN 'Capital'
	    WHEN CAST(mh.head_code AS INTEGER) >= 6000 AND CAST(mh.head_code AS INTEGER) < 8000 THEN 'Loan And Advances'
	    WHEN CAST(mh.head_code AS INTEGER) > 8000 THEN 'Public Head'
	    ELSE 'Below Major Head 2000'
END,
CONCAT(mh.head_code, ' -> ' ,mh.head_name),
CONCAT(dh.head_code, ' -> ' ,dh.head_name),
case 
	when h.plan_status_migration IS NOT NULL  
		then h.plan_status_migration
	when pc.abbreviation IS NOT NULL 
		then pc.abbreviation
	ELSE 'EE'
END, h.ga_ssa_status, h.voted_charged_status,
le.expenditure_date
