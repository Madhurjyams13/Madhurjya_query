SELECT substr(h.head,1,16), 
YEAR(a.payment_scroll_generated_on), 
month(a.payment_scroll_generated_on), 
#a.total_allowance, a.total_net_amount
#,a.*
ROUND( SUM(a.total_allowance)/10000000,2)
FROM ctmis_master.bill_details_base a
JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_id = ddo.hierarchy_Id
JOIN probityfinancials.heads h
	ON a.head_id = h.head_id
WHERE 
DATE(a.token_date) BETWEEN '2021-04-01' AND '2024-07-16'
AND a.approved_by IS NOT NULL 
AND ddo.hierarchy_Code = 'DIS/AAT/001'
AND a.stager_id IS NULL 
AND h.head LIKE '8342-00-117-0002%'
GROUP BY substr(h.head,1,16), YEAR(a.payment_scroll_generated_on), 
month(a.payment_scroll_generated_on)
ORDER BY 2,3
#ORDER BY a.token_date
