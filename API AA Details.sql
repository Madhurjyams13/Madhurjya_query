SELECT m.* FROM 
(
SELECT dep.hierarchy_Code,
case 
	when aa.parent_id IS NULL 
		then 'Original'
	when aa.aa_type IS NOT NULL 
		then 'Revision'
	when aa.aa_type IS NULL 
		then 'Revalidation'	
	ELSE 'Other'
END AS aa_type , 
case 
	when h.plan_status_migration IS NOT NULL  
		then h.plan_status_migration
	when pc.abbreviation IS NOT NULL 
		then pc.abbreviation
	ELSE 'EE'
END AS scheme,
aa.aa_issue_no, 
date(aa.approved_on),
CONCAT(
	h.head,'-',
	case 
	when h.plan_status_migration IS NOT NULL  
		then h.plan_status_migration
	when pc.abbreviation IS NOT NULL 
		then pc.abbreviation
	ELSE 'EE'
	END, '-',
	h.ga_ssa_status,'-', h.voted_charged_status) head,
CONCAT(SUBSTR(aa.fin_year,1,5),'20',SUBSTR(aa.fin_year,6,8)) finYear,
aa.project_name,
aa.amount,
ah.amount head_amount,
aa.project_aim, 
'filePath',
ddo.hierarchy_Code,
ofc.office_Name
#,h.*
#aa.* 
FROM probityfinancials.administrative_approval aa
LEFT JOIN probityfinancials.administrative_approval_heads ah
	ON aa.approval_id = ah.approval_id
LEFT JOIN probityfinancials.heads h
	ON ah.head_id = h.head_id  
JOIN pfmaster.hierarchy_setup dep
	ON aa.dept_id = dep.hierarchy_Id
	AND dep.category = 'D'
LEFT JOIN probityfinancials.plan_category_head_mapping pchm
	ON h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc 
	ON pchm.pc_id = pc.pc_id
LEFT JOIN probityfinancials.administrative_approval_ddo_mapping map
	ON aa.approval_id = map.approval_id
JOIN pfmaster.hierarchy_setup ddo
	ON map.mapped_ddo_id = ddo.hierarchy_Id
	AND ddo.category = 'S'
JOIN pfmaster.hierarchy_setup ofc
	ON ddo.parent_hierarchy = ofc.hierarchy_Id
	AND ofc.category = 'O'
WHERE
dep.hierarchy_Code = '31'
AND DATE(aa.issued_on) BETWEEN '2025-01-01' AND '2025-01-10'
AND CONCAT(SUBSTR(aa.fin_year,1,5),'20',SUBSTR(aa.fin_year,6,8)) = '2024-2025'
ORDER BY aa.approval_id DESC 
) m

