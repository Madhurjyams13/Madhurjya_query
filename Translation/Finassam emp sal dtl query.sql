SELECT a.id, a.total_net_amount, try.hierarchy_Code, emp.beneficiary_bank_account ACCOUNT_NUMBER, st.ddo_code DDO_CODE, 
t.token, DATE(t.token_date), a.pay_year,
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
END AS pay_month, (emp.allowance - emp.deduction) AMOUNT ,  DATE(t.token_date) CREATE_DATE, '' MODIFIED_UID, '' MODIFIED_DATE,
UPPER(emp.beneficiary_name) EMP_NAME, 'O' BILL_TYPE 
,'------',emp.beneficiary_code, emp.beneficiary_bank_account, emp.beneficiary_type, emp.beneficiary_id
#,'-----',emp.*, '-----------', a.*
FROM ctmis_master.bill_details_base a 
JOIN ctmis_master.token_master t
	ON a.token_id = t.id	
JOIN pfmaster.hierarchy_setup try 
	ON a.treasury_id = try.hierarchy_Id
	AND try.category = 'T'
LEFT JOIN ctmis_staging.staging_bill_details_base st
	ON a.stager_id = st.id
JOIN ctmis_master.bill_details_beneficiary emp
	ON a.id = emp.bill_base
WHERE
try.hierarchy_Code = 'KKJ'
AND DATE(a.token_date) >= '2023-11-28'
ORDER BY a.id DESC 