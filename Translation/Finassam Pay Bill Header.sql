SELECT t.token, DATE(t.token_date), try.hierarchy_Code, st.ddo_code ,   
a.bill_number, a.bill_date, 
case
	when a.pay_month = 1 then 'Jan'
	when a.pay_month = 2 then 'Feb'
	when a.pay_month = 3 then 'Mar'
	when a.pay_month = 4 then 'Apr'
	when a.pay_month = 5 then 'May'
	when a.pay_month = 6 then 'Jun'
	when a.pay_month = 7 then 'Jul'
	when a.pay_month = 8 then 'Aug'
	when a.pay_month = 9 then 'Sep'
	when a.pay_month = 10 then 'Oct'
	when a.pay_month = 11 then 'Nov'
	when a.pay_month = 12 then 'Dec'
	ELSE NULL 
END AS pay_month, 
a.pay_year, IFNULL(a.bill_group,0) , 'AS', 'N', a.total_allowance, (a.total_allowance - a.total_deduction ) ,
a.remarks, '' CREATE_UID ,DATE(t.token_date),'' MODIFIED_UID,'' MODIFIED_DATE, REPLACE (a.voucher_number, '/0', '/'), date(a.voucher_date), 
case
	when a.approved_by IS NOT NULL 
		then 'A'
	when a.rejected_by IS NOT NULL 
		then 'R'
	when a.objected_by IS NOT NULL 
		then 'O'
	when a.approved_by IS NULL AND a.rejected_by IS NULL
		then 'P'
END processing_flag, 
'' WRITE_OFF, st.head_of_account,  a.sanction_name, a.sanction_number, a.sanction_date, '' PAY_TYPE , a.sub_type ,'' MODIFIED_UID , '' EMPLOYEE_ID , '' EMPLOYEE_NAME ,
'' REFUND_TYPE, 
SUBSTR(st.head_of_account,1,4) MAJOR_HEAD,
CONCAT(st.source_bill_type, st.source_bill_id) SALARY_ID, a.head_id, 
#'-----------',
#,st.* #, '------------', a.* 
FROM ctmis_master.bill_details_base a 
JOIN ctmis_master.token_master t
	ON a.token_id = t.id	
JOIN pfmaster.hierarchy_setup try 
	ON a.treasury_id = try.hierarchy_Id
	AND try.category = 'T'
LEFT JOIN ctmis_staging.staging_bill_details_base st
	ON a.stager_id = st.id
WHERE
try.hierarchy_Code = 'KKJ'
AND DATE(a.token_date) >= '2023-11-28'
