SELECT i.proprietary, 
p.bank_ifsc, COUNT(*)
FROM ctmis_staging.staging_bill_details_base a
JOIN ctmis_master.bill_details_base b
	ON a.id = b.stager_id
JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_id = ddo.hierarchy_Id
	AND ddo.category = 'S'
JOIN ctmis_master.payment_bills_history pb
	ON b.id = pb.bill_details_base_id
JOIN ctmis_master.payment_bill_details_history p
	ON pb.id = p.payment_bill_history_id
JOIN ctmis_staging_epayments.
	staging_payments_acknowledgement_transaction i
	ON p.payment_acknowledgement = i.id  
WHERE
ddo.hierarchy_Code = 'DIS/FEB/001'
AND date(a.received_on) BETWEEN '2024-09-01' 
	AND '2024-09-15'
AND a.head_of_account_id = 68692
#AND b.approved_by IS NOT NULL 
AND p.payment_acknowledgement_status <> 'ACCP'
GROUP BY i.proprietary, p.bank_ifsc
LIMIT 0,400
