SELECT 
m.try "Treasury"
#m.bill_status "Status" 
, count(m.bill) "No of Bills" , 
SUM(m.gross) "Amount", round(SUM(m.gross)/10000000,2) "Amount in Cr"
FROM 
(
	SELECT 
	DISTINCT
	case 
	 when 
	 	c.rejected_by IS NOT NULL 
	 	 then 'Non GST Compliance Rejected Bills' 
		ELSE 'Non GST Compliance Pending Bills'
	END AS bill_status, tr.hierarchy_Name try, c.bill_number bill, 
	c.total_allowance gross, c.total_deduction deduction, c.total_net_amount net  
	FROM 
	ctmis_master.bill_details_base c
	JOIN ctmis_master.bill_details_beneficiary a
		ON c.id=a.bill_base
	JOIN vendor_database.commitment_vendor v
		ON a.beneficiary_id= v.vendor_id
	JOIN pfmaster.hierarchy_setup tr
		ON c.treasury_id= tr.hierarchy_Id
		AND tr.category = 'T'
	WHERE a.beneficiary_type='V' 
	AND DATE(c.accepted_on) between '2024-11-11' AND DATE(NOW())
	AND a.compliance='NC'
	AND v.vendor_gstin IS NOT null
	AND c.approved_by IS NULL #AND c.rejected_by IS NULL 
	
	UNION ALL
	
	SELECT 
	DISTINCT
	'Non GST Compliance Approved Bills' bill_status, tr.hierarchy_Name, c.bill_number, 
	c.total_allowance, c.total_deduction, c.total_net_amount  
	FROM 
	ctmis_master.bill_details_base c
	JOIN ctmis_master.bill_details_beneficiary a
		ON c.id=a.bill_base
	JOIN vendor_database.commitment_vendor v
		ON a.beneficiary_id= v.vendor_id
	JOIN pfmaster.hierarchy_setup tr
		ON c.treasury_id= tr.hierarchy_Id
		AND tr.category = 'T'
	WHERE a.beneficiary_type='V' 
	AND DATE(c.approved_on) between '2024-11-11' AND DATE(NOW())
	AND a.compliance='NC'
	AND v.vendor_gstin IS NOT null
	AND c.approved_by IS NOT NULL 
) m
#WHERE m.bill_status = 'Non GST Compliance Pending Bills' 
GROUP BY #
m.try
#m.bill_status

ORDER BY 1,2