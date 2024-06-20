SELECT #DATE(a.payment_processed_on), 
CONCAT(mh.head_code,'->',mh.head_name), 
CONCAT(dh.head_code,'->',dh.head_name), 
SUM(c.total_allowance), SUM(c.total_net_amount) 
#a.*, b.* 
FROM ctmis_master.payment_base a 
JOIN ctmis_master.payment_bills b
	ON a.id = b.payment_base_id
JOIN ctmis_master.bill_details_base c
	ON b.bill_details_base_id = c.id
JOIN probityfinancials.heads h
	ON c.head_id = h.head_id
JOIN probityfinancials.head_setup mh
	ON h.major_head = mh.head_setup_id
JOIN probityfinancials.head_setup dh
	ON h.detailed_head = dh.head_setup_id
WHERE date(a.payment_processed_on) = '2024-06-14'
GROUP BY
CONCAT(mh.head_code,'->',mh.head_name), 
CONCAT(dh.head_code,'->',dh.head_name)
ORDER BY 2,1

