SELECT 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'Plan'
END AS "Scheme",
ROUND(SUM(b.allotted_amount)/100,2) "Amount in Cr"
#a.*, b.* 
FROM probityfinancials.budget_allocation_base a 
JOIN probityfinancials.budget_allocation_details b 
	ON a.id = b.base_Id
JOIN probityfinancials.heads h 
	ON b.head_id = h.head_id
LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
	ON	h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc 
	ON	pchm.pc_id = pc.pc_id
WHERE a.year IN ('2023-24')
GROUP BY 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'Plan'
END
ORDER BY 1

