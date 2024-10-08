SELECT 'Bill', tr.hierarchy_Name, ddo.hierarchy_Code, a.bill_number,
a.bill_date, a.remarks, a.total_allowance, DATE_FORMAT(a.received_on,'%d-%m-%Y'),
timestampdiff(DAY,a.received_on,a.accepted_on), 
DATE_FORMAT(a.accepted_on,'%d-%m-%Y'), 
timestampdiff(DAY,a.accepted_on,a.voucher_date), 
DATE_FORMAT(a.voucher_date,'%d-%m-%Y') 
FROM ctmis_master.bill_details_base a
JOIN pfmaster.hierarchy_setup tr
	ON a.treasury_id = tr.hierarchy_Id
	AND tr.category = 'T' 
JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_id = ddo.hierarchy_Id
LEFT JOIN probityfinancials.heads h 
	ON a.head_id = h.head_id
LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
	ON	h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc
	ON	pchm.pc_id = pc.pc_id
WHERE
date(a.voucher_date) BETWEEN '2023-04-01' AND '2024-05-10'
AND pc.abbreviation = 'CSS'
AND pc.pc_id IS NOT NULL 
AND a.stager_id IS NOT NULL 
ORDER BY a.id DESC