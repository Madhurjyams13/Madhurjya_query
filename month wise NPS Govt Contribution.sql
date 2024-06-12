SELECT substr(h.head,1,11), year(a.voucher_date), month(a.voucher_date), ROUND( SUM(a.total_allowance)/10000000,2)
FROM ctmis_master.bill_details_base a
JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_id = ddo.hierarchy_Id
JOIN probityfinancials.heads h
	ON a.head_id = h.head_id
WHERE 
DATE(a.voucher_date) BETWEEN '2023-04-01' AND '2024-03-31'
AND a.approved_by IS NOT NULL 
#AND ddo.hierarchy_Code = 'DIS/AAT/001'
AND h.head LIKE '2071-%'
#AND a.voucher_date IS NOT NULL 
#AND a.total_net_amount = 0
#AND a.head_id = 43872
GROUP BY substr(h.head,1,11), 
year(a.voucher_date), month(a.voucher_date)
ORDER BY 1,2
