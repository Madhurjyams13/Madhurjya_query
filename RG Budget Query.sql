SELECT pc.full_meaning "Scheme Description" , m.* FROM 
(
SELECT 
a.year "Financial Year",
gr.grant_no "Grant Number", 
gr.grant_desc "Grant Description",
gr.grant_assamese "Grant Description Assamese",
dep.hierarchy_Code "Department Code",
dep.hierarchy_Name "Department",
dir.hierarchy_Code "Directorate Code", 
dir.hierarchy_Name "Directodate",
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
	h.voted_charged_status) "HoA" , 
case 
	when cast(mjh.head_code AS INTEGER) 
concat(mjh.head_code,'-',mjh.head_name) "Major Head",
mjh.head_name_unicode "Major Head Assamese",
concat(smh.head_code,'-',smh.head_name) "Sub Major Head",
smh.head_name_unicode "Sub Major Head Assamese",
concat(mnh.head_code,'-',mnh.head_name) "Minor Head",
mnh.head_name_unicode "Minor Head Assamese",
concat(sh.head_code,'-',sh.head_name) "Sub Head",
sh.head_name_unicode "Sub Head Assamese",
concat(ssh.head_code,'-',ssh.head_name) "Sub Sub Head",
ssh.head_name_unicode "Sub Sub Head Assamese",
concat(dh.head_code,'-',dh.head_name) "Detail Head",
dh.head_name_unicode "Detail Head Assamese",
concat(sdh.head_code,'-',sdh.head_name) "Sub Detail Head",
sdh.head_name_unicode "Sub Detail Head Assamese",
case 
	when h.plan_status_migration IS NOT NULL  
		then h.plan_status_migration
	when pc.abbreviation IS NOT NULL 
		then pc.abbreviation
	ELSE 'EE'
END AS "Scheme",
b.allotted_amount "Amount in Lakhs"
#SUM(b.allotted_amount) bud
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
#WHERE 
#a.year = '2024-25'
) m
JOIN probityfinancials.plan_category pc
	ON m.scheme = pc.abbreviation
#WHERE
#pc.full_meaning = 'Centrally Sponsored Scheme'
#LIMIT 100
#ORDER BY 10