SELECT dm.district_Name, dep.hierarchy_Name,
concat(dh.head_code,'->',dh.head_name),
SUM(a.total_allowance), 
round(SUM(a.total_allowance)/10000000,2)
FROM ctmis_master.bill_details_base a
JOIN probityfinancials.heads h
	ON a.head_id = h.head_id
JOIN probityfinancials.head_setup dh
	ON h.detailed_head = dh.head_setup_id
JOIN pfmaster.hierarchy_setup dep 
	ON a.department_id = dep.hierarchy_Id
	AND dep.category = 'D'
JOIN probityfinancials.ddo_setup dis
	ON a.ddo_id = dis.ddo_id
JOIN probityfinancials.district_setup dm
	ON dis.district_id = dm.district_Id
WHERE
dh.head_code IN ('01','02')
AND date(a.voucher_date) BETWEEN '2021-04-01' AND '2022-03-31'
GROUP BY dm.district_Name, dep.hierarchy_Name,
concat(dh.head_code,'->',dh.head_name)
ORDER BY 1,2,3