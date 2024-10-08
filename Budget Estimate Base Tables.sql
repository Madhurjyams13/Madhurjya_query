SELECT concat(gr.grant_no, ' -> ', gr.grant_desc) demand,
concat(dep.hierarchy_Code, ' - >', dep.hierarchy_Name) department ,
CONCAT(sdh.head_code , ' -> ', sdh.head_name),
CONCAT(sh.head_code , ' -> ', sh.head_name),
CONCAT(ssh.head_code , ' -> ', ssh.head_name),
sum(b.allotted_amount)
#a.*, '----->' ,b.*
FROM probityfinancials.budget_allocation_base a
JOIN probityfinancials.budget_allocation_details b
	ON a.id = b.base_id
JOIN probityfinancials.heads h
	ON b.head_id = h.head_id
JOIN probityfinancials.head_setup dh
	ON h.detailed_head = dh.head_setup_id
JOIN probityfinancials.head_setup sdh
	ON h.sub_detailed_head = sdh.head_setup_id
JOIN probityfinancials.head_setup sh
	ON h.sub_head = sh.head_setup_id
JOIN probityfinancials.head_setup ssh
	ON h.sub_sub_head = ssh.head_setup_id
JOIN probityfinancials.grant_setup gr
	ON b.grant_id = gr.id
JOIN pfmaster.hierarchy_setup dep
	ON a.parent = dep.hierarchy_Id
WHERE
a.year = '2023-24'
#AND dh.head_code = '99'
GROUP BY 
concat(gr.grant_no, ' -> ', gr.grant_desc) ,
concat(dep.hierarchy_Code, ' - >', dep.hierarchy_Name)  ,
CONCAT(sdh.head_code , ' -> ', sdh.head_name),
CONCAT(sh.head_code , ' -> ', sh.head_name),
CONCAT(ssh.head_code , ' -> ', ssh.head_name)
ORDER BY 1,2,3
#LIMIT 0,10	