SELECT pc.full_meaning scheme_desc , m.* FROM 
(
SELECT 
a.year,
gr.grant_no, 
gr.grant_desc,
gr.grant_assamese,
dep.hierarchy_Code dept_code,
dep.hierarchy_Name department,
dir.hierarchy_Code dir_code, 
dir.hierarchy_Name directorate,
CONCAT(
	h.head, '-',
	case 
	when h.plan_status_migration IS NOT NULL  
		then h.plan_status_migration
	when pc.abbreviation IS NOT NULL 
		then pc.abbreviation
	ELSE 'EE'
	END, '-',
	h.ga_ssa_status, '-',
	h.voted_charged_status) head , 
concat(mjh.head_code,'-',mjh.head_name) major_desc,
mjh.head_name_unicode major_unicode,
concat(smh.head_code,'-',smh.head_name) sub_major_desc,
smh.head_name_unicode sub_major_unicode,
concat(mnh.head_code,'-',mnh.head_name) minor_desc,
mnh.head_name_unicode minor_unicode,
concat(sh.head_code,'-',sh.head_name) sub_desc,
sh.head_name_unicode sub_unicode,
concat(ssh.head_code,'-',ssh.head_name) sub_sub_desc,
ssh.head_name_unicode sub_sub_unicode,
concat(dh.head_code,'-',dh.head_name) detail_desc,
dh.head_name_unicode detail_unicode,
concat(sdh.head_code,'-',sdh.head_name) sub_detail_desc,
sdh.head_name_unicode sub_detail_unicode,
case 
	when h.plan_status_migration IS NOT NULL  
		then h.plan_status_migration
	when pc.abbreviation IS NOT NULL 
		then pc.abbreviation
	ELSE 'EE'
END AS scheme,
SUM(b.allotted_amount) bud
FROM probityfinancials.budget_allocation_base a
JOIN probityfinancials.budget_allocation_details b
	ON a.id = b.base_id
JOIN pfmaster.hierarchy_setup dir
	ON a.office_id = dir.hierarchy_Id
	AND dir.category = 'R'
JOIN pfmaster.hierarchy_setup dep
	ON dir.parent_hierarchy = dep.hierarchy_Id
	AND dep.category = 'D'
JOIN probityfinancials.grant_setup gr
	ON b.grant_id = gr.id
JOIN probityfinancials.heads h
	ON b.head_id = h.head_id
LEFT JOIN probityfinancials.plan_category_head_mapping pchm
	ON h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc 
	ON pchm.pc_id = pc.pc_id
JOIN probityfinancials.head_setup mjh
	ON h.major_head = mjh.head_setup_id
	AND mjh.type = 'MJH'
JOIN probityfinancials.head_setup smh
	ON h.sub_major_head = smh.head_setup_id
	AND smh.`type` = 'SMH'
JOIN probityfinancials.head_setup mnh
	ON h.minor_head = mnh.head_setup_id
	AND mnh.`type` = 'MNH'
JOIN probityfinancials.head_setup sh
	ON h.sub_head = sh.head_setup_id
	AND sh.`type` = 'SH'
JOIN probityfinancials.head_setup ssh
	ON h.sub_sub_head = ssh.head_setup_id
	AND ssh.`type` = 'SSH'
JOIN probityfinancials.head_setup dh
	ON h.detailed_head = dh.head_setup_id
	AND dh.`type` = 'DH'
JOIN probityfinancials.head_setup sdh
	ON h.sub_detailed_head = sdh.head_setup_id
	AND sdh.`type` = 'SDH'
WHERE
a.year = '2024-25'
GROUP BY 
gr.grant_no, 
gr.grant_desc,
gr.grant_assamese,
dep.hierarchy_Code ,
dep.hierarchy_Name ,
dir.hierarchy_Code , 
dir.hierarchy_Name ,
CONCAT(
	h.head, '-',
	case 
	when h.plan_status_migration IS NOT NULL  
		then h.plan_status_migration
	when pc.abbreviation IS NOT NULL 
		then pc.abbreviation
	ELSE 'EE'
	END, '-',
	h.ga_ssa_status, '-',
	h.voted_charged_status), 
concat(mjh.head_code,'-',mjh.head_name),
mjh.head_name_unicode,
concat(smh.head_code,'-',smh.head_name),
smh.head_name_unicode,
concat(mnh.head_code,'-',mnh.head_name),
mnh.head_name_unicode,
concat(sh.head_code,'-',sh.head_name),
sh.head_name_unicode,
concat(ssh.head_code,'-',ssh.head_name),
ssh.head_name_unicode,
concat(dh.head_code,'-',dh.head_name),
dh.head_name_unicode,
concat(sdh.head_code,'-',sdh.head_name),
sdh.head_name_unicode,
case 
	when h.plan_status_migration IS NOT NULL  
		then h.plan_status_migration
	when pc.abbreviation IS NOT NULL 
		then pc.abbreviation
	ELSE 'EE'
END
) m
JOIN probityfinancials.plan_category pc
	ON m.scheme = pc.abbreviation
WHERE 
m.year = '2024-25'

#LIMIT 100