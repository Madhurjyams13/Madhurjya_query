SELECT a.id, ddo.hierarchy_Code, st.bill_no, st.bill_date, st.remarks , 
st.incumbent_count, st.gross_pay, pb.token_number,
case 
	when 
		st.validated IS NULL OR st.validation_status <> 'A' then 'Pending for Validation'
	when 
		a.accepted_by IS NULL then 'Pending for Token Generation'
	when 
		a.rejected_by IS NOT NULL then 'Rejected by Treasury'	
	when 
		a.accepted_by IS NOT NULL AND a.approved_by IS NULL then 'Processing at Treasuries'
	when 
		a.approved_by IS NOT NULL AND pb.token_number IS NULL then 'Approved by Treasury'
	when 
		pb.token_number IS NOT NULL AND pb.biz_msg_idr IS NULL then 'Scroll Generated'
	when 
		pb.biz_msg_idr IS NOT NULL then 'Uploaded to eKuber'	
END AS STATUS,
a.token_number, a.approved_on
#,'----',pb.*
FROM ctmis_staging.staging_bill_details_base st
LEFT JOIN ctmis_master.bill_details_base a
	ON st.id = a.stager_id
JOIN pfmaster.hierarchy_setup ddo
	ON st.ddo_id = ddo.hierarchy_Id 
LEFT JOIN ctmis_master.payment_bills pbi
	ON a.id = pbi.bill_details_base_id
LEFT JOIN ctmis_master.payment_base pb
	ON pbi.payment_base_id = pb.id
WHERE
#st.treasury_code = 'UDG'
st.source_bill_type = 'GA' 
#a.id = 16598355
#a.bill_number LIKE 'BILL/202425/HFLPWB011/0003%'
AND ddo.hierarchy_Code = 'DIS/FEB/001' 
AND date(st.entry_date) BETWEEN '2024-05-25' AND '2024-06-05'
#AND st.gross_pay/st.incumbent_count = 1250
/*AND (
	    UPPER(st.remarks) LIKE '%ORUN%' OR
	    UPPER(st.remarks) LIKE '%DIDS%' OR
	    UPPER(st.remarks) LIKE '%DAYAL%' OR
	    UPPER(st.remarks) LIKE '%INDIRA%' OR
	    UPPER(st.remarks) LIKE '%DD%' OR
	    UPPER(st.remarks) LIKE '%IMUW%'
	 )*/
ORDER BY st.id DESC