SELECT a.pay_year, a.pay_month, 
SUBSTR(ben.beneficiary_bank_ifsc,1,4) bank, 
ben.beneficiary_bank_ifsc ifsc, 
COUNT(ben.beneficiary_id) count
 #, SUM(st.incumbent_count) 
	FROM ctmis_master.bill_details_base a
	JOIN pfmaster.hierarchy_setup b
		ON a.ddo_id = b.hierarchy_Id
	JOIN ctmis_staging.staging_bill_details_base st
		ON a.stager_id = st.id
	JOIN ctmis_master.bill_details_beneficiary ben
		ON a.id = ben.bill_base
	WHERE
	b.hierarchy_Code = 'DIS/FEB/001'
	AND a.sub_type LIKE 'GA%'
	AND date(a.token_date) BETWEEN '2024-05-25' AND  
		'2024-06-15'
	AND a.approved_by IS NOT NULL  
	AND st.gross_pay/1250 = st.incumbent_count
GROUP BY SUBSTR(ben.beneficiary_bank_ifsc,1,4), 
ben.beneficiary_bank_ifsc, a.pay_month, a.pay_year
ORDER BY 1,2,3,5 DESC 