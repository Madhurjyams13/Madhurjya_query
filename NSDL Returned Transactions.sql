SELECT tr.hierarchy_Name, a.head_id, c.* 
#SUM(a.total_allowance),COUNT(c.end_to_end_id)
#a.bill_number, a.total_allowance, b.id, c.* 
FROM ctmis_master.bill_details_base a
JOIN ctmis_master.payment_bills b
	ON a.id = b.bill_details_base_id
JOIN ctmis_master.payment_bill_details c
	ON b.id = c.payment_bill_id
JOIN pfmaster.hierarchy_setup tr
	ON a.treasury_id = tr.hierarchy_Id
	AND tr.category = 'T'
WHERE
DATE(a.voucher_date) BETWEEN '2024-04-01' AND '2024-12-16'
AND a.sub_type = 'MISC_NSDL'
AND c.return_notification_status IS NOT NULL 
#GROUP BY tr.hierarchy_Name, a.head_id
ORDER BY 1
#ORDER BY 1 DESC  