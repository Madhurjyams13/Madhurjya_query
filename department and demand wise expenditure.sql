SELECT gr.grant_no, gr.grant_desc, 
dep.hierarchy_Code dep_code, dep.hierarchy_Name dep_name,
ddo.hierarchy_Code ddo_code, ddo.hierarchy_Name,
h.head, 
CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'EE'
	END AS scheme,
h.ga_ssa_status, h.voted_charged_status, 
sum(b.total_allowance), sum(b.total_net_amount), SUM(b.total_deduction)
#le.* 
FROM ctmis_accounts.ledger_expenditure le 
JOIN ctmis_master.bill_details_base b
	ON le.source_reference = b.id
	AND le.source_category = 'BILLS'
JOIN probityfinancials.heads h
	ON le.head_of_account = h.head_id
LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
	ON	h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc 
	ON	pchm.pc_id = pc.pc_id
JOIN pfmaster.hierarchy_setup dep 
	ON le.department = dep.hierarchy_Id
	AND dep.category = 'D'
JOIN pfmaster.hierarchy_setup ddo 
	ON le.ddo = ddo.hierarchy_Id
	AND ddo.category = 'S'
LEFT JOIN probityfinancials.grant_setup gr
	ON le.demand = gr.id
WHERE
date(le.expenditure_date) BETWEEN '2023-05-01' AND '2024-03-31'
#AND gr.grant_no LIKE '59%'
AND dep.hierarchy_Code LIKE '59%'
GROUP BY
gr.grant_no, gr.grant_desc, 
dep.hierarchy_Code, dep.hierarchy_Name,
ddo.hierarchy_Code, ddo.hierarchy_Name,
h.head, 
CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'EE'
	END,
h.ga_ssa_status, h.voted_charged_status

UNION ALL 

SELECT gr.grant_no, gr.grant_desc, 
dep.hierarchy_Code, dep.hierarchy_Name,
ddo.hierarchy_Code, ddo.hierarchy_Name,
h.head, 
CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'EE'
	END AS scheme,
h.ga_ssa_status, h.voted_charged_status, 
sum(bd.amount), sum(bd.net_amount), sum(bd.amount- bd.net_amount)
#le.* 
FROM ctmis_accounts.ledger_expenditure le 
JOIN ctmis_master.pay_cheque_base b
	ON le.source_reference = b.id
	AND le.source_category = 'CHEQUE'
JOIN ctmis_master.pay_cheque_details bd
	ON b.id = bd.base_id
JOIN probityfinancials.heads h
	ON bd.ddo_account_head = h.head_id
LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
	ON	h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc 
	ON	pchm.pc_id = pc.pc_id
JOIN pfmaster.hierarchy_setup dep 
	ON le.department = dep.hierarchy_Id
	AND dep.category = 'D'
JOIN pfmaster.hierarchy_setup ddo 
	ON le.ddo = ddo.hierarchy_Id
	AND ddo.category = 'S'
JOIN probityfinancials.grant_setup gr
	ON le.demand = gr.id
WHERE
date(le.expenditure_date) BETWEEN '2023-04-01' AND '2024-03-31'
#AND gr.grant_no LIKE '59%'
AND dep.hierarchy_Code LIKE '59%'
ORDER BY 1,4,5,7,8,9,10
