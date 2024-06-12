
	SELECT m.dep , m.ddo, m.mhead, m.scheme,  SUM(amt) expen 
	FROM
	(
		SELECT dep.hierarchy_Name dep, ddo.hierarchy_Code ddo,
		CONCAT( mh.head_code, '->', mh.head_name) mhead, 
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END AS scheme,
		ROUND ( SUM(le.amount)/100000 , 2) amt
		FROM ctmis_accounts.ledger_expenditure le
		LEFT JOIN probityfinancials.heads h
		ON le.head_of_account = h.head_id
		LEFT JOIN pfmaster.hierarchy_setup dep
		ON le.department = dep.hierarchy_Id
		AND dep.category = 'D'
		JOIN probityfinancials.head_setup mh
		ON h.major_head = mh.head_setup_id
		LEFT JOIN probityfinancials.plan_category_head_mapping pchm
		ON h.head_id = pchm.head_id
		LEFT JOIN probityfinancials.plan_category pc
		ON pchm.pc_id = pc.pc_id
		LEFT JOIN ctmis_master.bill_details_base b
		ON le.source_reference = b.id
		LEFT JOIN pfmaster.hierarchy_setup ddo
		ON le.ddo = ddo.hierarchy_Id
		WHERE
		date(le.expenditure_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
		AND le.financial_year = '2023-24'
		AND le.source_category = 'BILLS'
		AND SUBSTR(h.head,1,4) <> '2071'
		AND b.bill_pension_type IS NULL
		AND SUBSTR(h.head, 22,2)<>'21'
		GROUP BY dep.hierarchy_Name,
		CONCAT( mh.head_code, '->', mh.head_name),
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END, ddo.hierarchy_Code
		
		UNION ALL
		
		SELECT 'Pension' dep, ddo.hierarchy_Code,
		CONCAT( mh.head_code, '->', mh.head_name) mhead,
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END AS scheme,
		ROUND ( SUM(le.amount)/100000 , 2) amt
		FROM ctmis_accounts.ledger_expenditure le
		LEFT JOIN probityfinancials.heads h
		ON le.head_of_account = h.head_id
		LEFT JOIN pfmaster.hierarchy_setup dep
		ON le.department = dep.hierarchy_Id
		AND dep.category = 'D'
		JOIN probityfinancials.head_setup mh
		ON h.major_head = mh.head_setup_id
		LEFT JOIN probityfinancials.plan_category_head_mapping pchm
		ON h.head_id = pchm.head_id
		LEFT JOIN probityfinancials.plan_category pc
		ON pchm.pc_id = pc.pc_id
		LEFT JOIN ctmis_master.bill_details_base b
		ON le.source_reference = b.id
		LEFT JOIN pfmaster.hierarchy_setup ddo
		ON le.ddo = ddo.hierarchy_Id
		WHERE
		DATE(b.voucher_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
		AND le.financial_year = '2023-24'
		AND le.source_category = 'BILLS'
		AND ( SUBSTR(h.head,1,4) = '2071' OR b.bill_pension_type IS NOT NULL or SUBSTR(h.head, 22,2)='21' )
		GROUP BY #dep.hierarchy_Name,
		CONCAT( mh.head_code, '->', mh.head_name),
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END, ddo.hierarchy_Code
		
		UNION ALL
		
		SELECT dep.hierarchy_Name,  ddo.hierarchy_Code,
		CONCAT( mh.head_code, '->', mh.head_name) mhead,
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END AS scheme,
		ROUND ( SUM(le.amount)/100000 , 2) amt
		FROM ctmis_accounts.ledger_expenditure le
		LEFT JOIN ctmis_master.pay_cheque_base b
				ON le.source_reference = b.id 
				AND le.source_category = 'CHEQUE'
		JOIN ctmis_master.pay_cheque_details bd
				ON b.id = bd.base_id
		LEFT JOIN probityfinancials.heads h 
				ON bd.ddo_account_head = h.head_id
		LEFT JOIN pfmaster.hierarchy_setup dep
		ON le.department = dep.hierarchy_Id
		AND dep.category = 'D'
		JOIN probityfinancials.head_setup mh
		ON h.major_head = mh.head_setup_id
		LEFT JOIN probityfinancials.plan_category_head_mapping pchm
		ON h.head_id = pchm.head_id
		LEFT JOIN probityfinancials.plan_category pc
		ON pchm.pc_id = pc.pc_id
		LEFT JOIN pfmaster.hierarchy_setup ddo
		ON le.ddo = ddo.hierarchy_Id
		#JOIN ctmis_master.bill_details_base b
		# ON le.source_reference = b.id
		WHERE
		date(le.expenditure_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
		AND le.financial_year = '2023-24'
		AND le.source_category = 'CHEQUE'
		GROUP BY dep.hierarchy_Name,
		CONCAT( mh.head_code, '->', mh.head_name),
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END, ddo.hierarchy_Code
	) m
	WHERE m.dep IS NOT NULL
	GROUP BY m.dep, m.ddo, m.mhead, m.scheme
	ORDER BY 1,2,3,4
