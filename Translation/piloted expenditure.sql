SELECT 
mh.head_code, 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'Plan'
END AS scheme, 
substr(dep.hierarchy_Code,1,2), 
try.hierarchy_Code, date(le.expenditure_date), 9999, sum(le.amount), 0, dh.head_code,	gr.grant_no#,  h.head, h.ga_ssa_status, h.voted_charged_status
FROM ctmis_accounts.ledger_expenditure le
JOIN pfmaster.hierarchy_setup try 
	ON le.treasury = try.hierarchy_Id
JOIN probityfinancials.heads h 
	ON le.head_of_account = h.head_id
JOIN probityfinancials.head_setup mh
	ON h.major_head = mh.head_setup_id
JOIN pfmaster.hierarchy_setup dep
	ON le.department = dep.hierarchy_Id
LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
	ON	h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc 
	ON	pchm.pc_id = pc.pc_id
JOIN probityfinancials.head_setup dh 
	ON h.detailed_head = dh.head_setup_id
JOIN probityfinancials.grant_setup gr
	ON le.demand = gr.id
WHERE
try.hierarchy_Code IN ( 'KKJ' , 'AKM')
AND date(le.expenditure_date) >= '2023-11-28'
GROUP BY mh.head_code, 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'Plan'
END, 
substr(dep.hierarchy_Code,1,2), 
try.hierarchy_Code, date(le.expenditure_date), dh.head_code,	gr.grant_no

UNION ALL

SELECT 
mh.head_code, 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'Plan'
END AS scheme, 
substr(dep.hierarchy_Code,1,2), 
try.hierarchy_Code, date(le.expenditure_date), 9999, sum(le.amount), 0, dh.head_code,	23#, h.head, h.ga_ssa_status, h.voted_charged_status
FROM ctmis_accounts.ledger_expenditure le
JOIN pfmaster.hierarchy_setup try 
	ON le.treasury = try.hierarchy_Id
JOIN probityfinancials.heads h 
	ON le.head_of_account = h.head_id
JOIN probityfinancials.head_setup mh
	ON h.major_head = mh.head_setup_id
JOIN pfmaster.hierarchy_setup dep
	ON le.department = dep.hierarchy_Id
LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
	ON	h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc 
	ON	pchm.pc_id = pc.pc_id
JOIN probityfinancials.head_setup dh 
	ON h.detailed_head = dh.head_setup_id
WHERE
try.hierarchy_Code IN ( 'KKJ' , 'AKM')
AND date(le.expenditure_date) >= '2023-11-28'
AND le.demand IS NULL
AND mh.head_code IN ('2071','2075')
GROUP BY mh.head_code, 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'Plan'
END, 
substr(dep.hierarchy_Code,1,2), 
try.hierarchy_Code, date(le.expenditure_date), dh.head_code


UNION ALL 


SELECT 
mh.head_code, 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'Plan'
END AS scheme, 
substr(dep.hierarchy_Code,1,2), 
try.hierarchy_Code, date(le.expenditure_date), 9999, sum(le.amount), 0, dh.head_code,	gr.grant_no#, h.head, h.ga_ssa_status, h.voted_charged_status
FROM ctmis_accounts.ledger_expenditure le
JOIN pfmaster.hierarchy_setup try 
	ON le.treasury = try.hierarchy_Id
JOIN probityfinancials.heads h 
	ON le.head_of_account = h.head_id
JOIN probityfinancials.head_setup mh
	ON h.major_head = mh.head_setup_id
JOIN pfmaster.hierarchy_setup dep
	ON le.department = dep.hierarchy_Id
LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
	ON	h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc 
	ON	pchm.pc_id = pc.pc_id
JOIN probityfinancials.head_setup dh 
	ON h.detailed_head = dh.head_setup_id
JOIN probityfinancials.grant_setup gr
	ON le.demand = gr.id
WHERE
try.hierarchy_Code IN ( 'NDT','KLB','BKK', 'RGP','NDT')
AND date(le.expenditure_date) >= '2023-08-16'
GROUP BY mh.head_code, 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'Plan'
END, 
substr(dep.hierarchy_Code,1,2), 
try.hierarchy_Code, date(le.expenditure_date), dh.head_code,	gr.grant_no

UNION ALL

SELECT 
mh.head_code, 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'Plan'
END AS scheme, 
substr(dep.hierarchy_Code,1,2), 
try.hierarchy_Code, date(le.expenditure_date), 9999, sum(le.amount), 0, dh.head_code,	23#, h.head, h.ga_ssa_status, h.voted_charged_status
FROM ctmis_accounts.ledger_expenditure le
JOIN pfmaster.hierarchy_setup try 
	ON le.treasury = try.hierarchy_Id
JOIN probityfinancials.heads h 
	ON le.head_of_account = h.head_id
JOIN probityfinancials.head_setup mh
	ON h.major_head = mh.head_setup_id
JOIN pfmaster.hierarchy_setup dep
	ON le.department = dep.hierarchy_Id
LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
	ON	h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc 
	ON	pchm.pc_id = pc.pc_id
JOIN probityfinancials.head_setup dh 
	ON h.detailed_head = dh.head_setup_id
WHERE
try.hierarchy_Code IN ( 'NDT','KLB','BKK', 'RGP', 'NDT')
AND date(le.expenditure_date) >= '2023-08-16'
AND le.demand IS NULL
AND mh.head_code IN ('2071','2075')
GROUP BY mh.head_code, 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'Plan'
END, 
substr(dep.hierarchy_Code,1,2), 
try.hierarchy_Code, date(le.expenditure_date), dh.head_code