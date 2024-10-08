SELECT 
case 
	when m.dh IN ('01 -> Salaries', '02 -> Wages')
		then 'Salary - 01 & 02'
	when m.dh IN ('21 -> Pension / Gratuity')
		then 'Pension - 21'
	ELSE
		m.scheme
	END AS par, round(sum(m.amt),2) bamt
#m.* 
FROM 
(
SELECT concat(gr.grant_no, ' -> ', gr.grant_desc) demand,
concat(dep.hierarchy_Code, ' - >', dep.hierarchy_Name) department ,
CONCAT(dh.head_code , ' -> ', dh.head_name) dh,
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'EE'
END AS scheme,
sum(b.allotted_amount) amt
#a.*, '----->' ,b.*
FROM probityfinancials.budget_allocation_base a
JOIN probityfinancials.budget_allocation_details b
	ON a.id = b.base_id
JOIN probityfinancials.heads h
	ON b.head_id = h.head_id
JOIN probityfinancials.head_setup dh
	ON h.detailed_head = dh.head_setup_id
JOIN probityfinancials.grant_setup gr
	ON b.grant_id = gr.id
JOIN pfmaster.hierarchy_setup dep
	ON a.parent = dep.hierarchy_Id
LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
	ON	h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc 
	ON	pchm.pc_id = pc.pc_id
WHERE
a.year = '2023-24'
#AND dh.head_code = '99'
AND dep.hierarchy_Code = '01'
GROUP BY 
concat(gr.grant_no, ' -> ', gr.grant_desc) ,
concat(dep.hierarchy_Code, ' - >', dep.hierarchy_Name)  ,
CONCAT(dh.head_code , ' -> ', dh.head_name),
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'EE'
END
) m
group by case 
	when m.dh IN ('01 -> Salaries', '02 -> Wages')
		then 'Salary - 01 & 02'
	when m.dh IN ('21 -> Pension / Gratuity')
		then 'Pension - 21'
	ELSE
		m.scheme
	END
#ORDER BY 1,2,3
#LIMIT 0,10