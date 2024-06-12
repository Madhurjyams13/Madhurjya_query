SELECT a.id, a.total_allowance, a.total_deduction,
t.token, DATE(t.token_date), c.token challan_seq, DATE(c.challan_date), try.hierarchy_Code, 'N', 'AS', 
'' FOR_WHOM, st.ddo_code DEPOSITED_BY ,
rb.particulars, rb.total_receipt, rb.remarks , cm.transfer_type, '' CREATE_UID, DATE(c.challan_date) CREATE_DATE, 
'' MODIFIED_UID, '' MODIFIED_DATE, st.ddo_code DDO_CODE
,'--------' , cm.*
#,'-------' , hoa.*
,'-------' , rpyd.beneficiary_type, rpyd.beneficiary_id
#,'-------' , rpd.*
#,com.*, '---------'
#,'----------', rb.*
FROM ctmis_master.bill_details_base a 
JOIN ctmis_master.token_master t
	ON a.token_id = t.id	
JOIN pfmaster.hierarchy_setup try 
	ON a.treasury_id = try.hierarchy_Id
	AND try.category = 'T' 
JOIN ctmis_egras.receipt_base rb
	ON a.id = rb.source_reference
	AND rb.source_type = 'BILLS'
JOIN ctmis_master.challan_master c
	ON rb.challan_id = c.id
JOIN ctmis_dataset.bill_component_master cm 
	ON rb.source_master_code = cm.code
#JOIN ctmis_egras.receipt_hoa_details hoa
#	ON rb.id = hoa.receipt_base
JOIN ctmis_egras.receipt_payee_details rpyd
	ON rb.id = rpyd.receipt_base
#JOIN ctmis_egras.receipt_payer_details rpd
#	ON rb.id = rpd.receipt_base
LEFT JOIN ctmis_staging.staging_bill_details_base st
	ON a.stager_id = st.id
WHERE
try.hierarchy_Code = 'KKJ'
AND DATE(a.token_date) >= '2023-11-28'
#AND rpyd.beneficiary_type <> 'E'