SELECT a.sanction_number, a.sanction_date, 
a.bill_number, a.bill_date, a.total_allowance, a.total_net_amount, 
c.incumbent_name, c.bank_account, c.bank_ifsc,c.payment_acknowledgement_status, c.payment_acknowledgement_received_on,
c.net_amount, 
c.return_notification_status, c.crdit_date, 
c.end_to_end_id 
#,'----', b.*, '------', c.* 
FROM ctmis_master.bill_details_base a 
JOIN ctmis_master.bill_details_beneficiary b
	ON a.id = b.bill_base
LEFT JOIN ctmis_master.payment_bill_details c
	ON b.id = c.bill_detail_id
WHERE
a.id IN ( 16598355, 16517990)