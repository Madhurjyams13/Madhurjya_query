SELECT a.bill_number, b.payment_information_id, 
b.payment_acknowledgement,
b.payment_acknowledgement_status, 
pbd.incumbent_name, pbd.bank_account, 
pbd.bank_ifsc
FROM ctmis_master.bill_details_base a
JOIN ctmis_master.payment_bills b
	ON a.id = b.bill_details_base_id
JOIN ctmis_master.payment_base pb
	ON b.payment_base_id = pb.id
JOIN ctmis_master.payment_bill_details pbd
	ON b.id = pbd.payment_bill_id 
WHERE
a.id IN 
( 
18115661, 18115664,18115670
#SELECT c.id
#FROM ctmis_staging.staging_bill_details_base a
#JOIN pfmaster.hierarchy_setup ddo
#	ON a.ddo_id = ddo.hierarchy_Id
#	AND ddo.category = 'S'
#JOIN ctmis_master.bill_details_base c
#	ON a.id = c.stager_id
#WHERE
#ddo.hierarchy_Code = 'DIS/FEB/001'
#AND date(a.received_on) between '2024-09-01' AND '2024-09-20'
#AND a.head_of_account_id = 68692
)
AND pbd.bank_account LIKE ' %'
#AND pbd.incumbent_name REGEXP '[^a-zA-Z0-9. ]'
ORDER BY 1
