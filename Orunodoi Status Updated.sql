SELECT o.bill_status "Bill Status", o.pay_status "Payment Status", 
COUNT(o.bill_no) "Bills" , SUM(o.ben) "Beneficiaries", 
SUM(o.gross) "Amount", ROUND(SUM(o.gross)/10000000,2) "Amount in Cr" 
FROM 
(

SELECT a.bill_no, a.bill_date, a.incumbent_count ben, 
c.bill_number, c.total_allowance gross,
case 
	when c.approved_by IS NOT NULL then 'Approved'
	when c.rejected_by IS NOT NULL then 'Rejected'
	ELSE 'Processing'
END AS bill_status,
d.bill_details_base_id,
case 
	when d.bill_details_base_id IS NULL then 'Not Uploaded to RBI'
	when d.payment_acknowledgement_status = 'ACCP' then 'Accepted by RBI'
	when d.payment_acknowledgement_status = 'RJCT' then 'Rejected by RBI'
	when d.payment_acknowledgement_status IS NULL then 'Awaiting Acknowledgement'
	ELSE 'N/A'
END AS pay_status
FROM ctmis_staging.staging_bill_details_base a
JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_id = ddo.hierarchy_Id
	AND ddo.category = 'S'
JOIN ctmis_master.bill_details_base c
	ON a.id = c.stager_id
LEFT JOIN ctmis_master.payment_bills d
	ON c.id = d.bill_details_base_id
WHERE
ddo.hierarchy_Code = 'DIS/FEB/001'
AND date(a.received_on) >= '2024-10-01'
AND a.head_of_account_id = 68692

) o
GROUP BY o.bill_status, o.pay_status