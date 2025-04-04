SELECT 
'1. Bill Not Submitted to Treasury',
b.bill_number,
b.bill_date,
b.received_on,
dep.hierarchy_Name dep,
ddo.hierarchy_Code ddo, ofc.office_Name,
cd.ceiling_acc_no foc, cd.approved_on foc_date, 
cd.ceiling_valid valid_till,
round(fs.amount*100000,0) fs_amt,
round(cd.tot_Amount*100000,0) foc_amt,
round(fsb.amount*100000,0) ben_amt,
fs.fs_issue_no fs, fs.issued_on fs_date, 
v.vendor_name, v.vendor_address,
v.vendor_account, v.vendor_bank,
v.vendor_ifsc, v.vendor_gstin,
v.vendor_pan
#v.*
FROM probityfinancials.ceiling_distributed cd
JOIN probityfinancials.ceiling_request_checklist cl
	ON cd.checklist_Id = cl.id
JOIN pfmaster.hierarchy_setup ddo
	ON cd.office_id = ddo.hierarchy_Id
	AND ddo.category = 'S'
JOIN pfmaster.hierarchy_setup ofc
	ON ddo.parent_hierarchy = ofc.hierarchy_Id
	AND ofc.category = 'O'
JOIN pfmaster.hierarchy_setup dep
	ON cl.office = dep.hierarchy_Id
	AND dep.category = 'D'
LEFT JOIN probityfinancials.financial_sanction fs
	ON cl.fs_sanction_id = fs.sanction_id
LEFT JOIN probityfinancials.financial_sanction_beneficiary fsb
	ON fs.sanction_id = fsb.sanction_id
LEFT JOIN vendor_database.commitment_vendor v
	ON fsb.vendor_id = v.vendor_id
LEFT JOIN ctmis_master.bill_details_base b
	ON cd.ceiling_acc_no = b.foc_number
WHERE
cd.fin_year = '2024-25'
AND cl.fin_Approved_On IS NOT NULL 
AND cl.rejected_by IS NULL
AND cl.upload_approved_by IS NOT NULL 
AND cd.ceiling_valid >= date(NOW())
AND fsb.delete_status = 'N'
AND b.foc_number IS NULL 

UNION ALL 

SELECT 
case 
	when b.payment_scroll_generated_on IS NOT NULL 
		then '5. Payment Scroll Generated'
	when b.approved_on IS NOT NULL 
		then '4. Approved by Treasury'
	when b.accepted_on IS NOT NULL 
		then '3. Processing at Treasuries'
	ELSE '2. Token Not Generated at Treasuries'
END AS pstatus,		 
b.bill_number,	
b.bill_date,	
date(b.received_on),
dep.hierarchy_Name dep,
ddo.hierarchy_Code ddo, ofc.office_Name,
cd.ceiling_acc_no foc, cd.approved_on foc_date, 
cd.ceiling_valid valid_till,
round(fs.amount*100000,0) fs_amt,
round(cd.tot_Amount*100000,0) foc_amt,
round(fsb.amount*100000,0) ben_amt,
fs.fs_issue_no fs, fs.issued_on fs_date, 
v.vendor_name, v.vendor_address,
v.vendor_account, v.vendor_bank,
v.vendor_ifsc, v.vendor_gstin,
v.vendor_pan
#v.*
FROM probityfinancials.ceiling_distributed cd
JOIN probityfinancials.ceiling_request_checklist cl
	ON cd.checklist_Id = cl.id
JOIN pfmaster.hierarchy_setup ddo
	ON cd.office_id = ddo.hierarchy_Id
	AND ddo.category = 'S'
JOIN pfmaster.hierarchy_setup ofc
	ON ddo.parent_hierarchy = ofc.hierarchy_Id
	AND ofc.category = 'O'
JOIN pfmaster.hierarchy_setup dep
	ON cl.office = dep.hierarchy_Id
	AND dep.category = 'D'
LEFT JOIN probityfinancials.financial_sanction fs
	ON cl.fs_sanction_id = fs.sanction_id
LEFT JOIN probityfinancials.financial_sanction_beneficiary fsb
	ON fs.sanction_id = fsb.sanction_id
LEFT JOIN vendor_database.commitment_vendor v
	ON fsb.vendor_id = v.vendor_id
LEFT JOIN ctmis_master.bill_details_base b
	ON cd.ceiling_acc_no = b.foc_number
WHERE
cd.fin_year = '2024-25'
AND cl.fin_Approved_On IS NOT NULL 
AND cl.rejected_by IS NULL 
AND cl.upload_approved_by IS NOT NULL 
AND cd.ceiling_valid >= date(NOW())
AND fsb.delete_status = 'N'
AND b.foc_number IS NOT NULL
AND b.rejected_by IS NULL 
AND b.voucher_date IS NULL

ORDER BY 1,8,2


