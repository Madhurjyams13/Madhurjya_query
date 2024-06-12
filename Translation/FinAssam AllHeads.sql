SELECT m.head_id, m.head, SUBSTR(m.head,1, LENGTH(m.head)-6) head1,
m.plan_status, m.area_code, m.voted_charged ,
m.detail_head, m.sub_detail_head
FROM 
(
SELECT h.head_id,  h.head, dh.head_code detail_head, sdh.head_code sub_detail_head,
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status_migration IS NOT NULL THEN h.plan_status_migration
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'Plan'
END AS plan_status,
h.ga_ssa_status area_code, h.voted_charged_status voted_charged
FROM probityfinancials.heads h 
LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
	ON	h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc 
	ON	pchm.pc_id = pc.pc_id
JOIN probityfinancials.head_setup dh
	ON h.detailed_head = dh.head_setup_id
JOIN probityfinancials.head_setup sdh
	ON h.sub_detailed_head = sdh.head_setup_id	
) m

