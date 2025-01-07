SELECT DATE(c.return_notification_received_on),
tr.hierarchy_Name, 
SUM(c.net_amount) 
FROM ctmis_master.bill_details_base a
JOIN ctmis_master.payment_bills b
	ON a.id = b.bill_details_base_id
JOIN ctmis_master.payment_bill_details c
	ON b.id = c.payment_bill_id
JOIN pfmaster.hierarchy_setup tr
	ON a.treasury_id = tr.hierarchy_Id
	AND tr.category = 'T'
WHERE
DATE(a.voucher_date) BETWEEN '2024-04-01' AND '2024-12-20'
AND c.return_notification_status IS NOT NULL 
GROUP BY DATE(c.return_notification_received_on), tr.hierarchy_Name
ORDER BY 1,2