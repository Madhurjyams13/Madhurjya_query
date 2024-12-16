SELECT 
concat(dep.hierarchy_Code,'->',dep.hierarchy_Name),
concat(tr.hierarchy_Code,'->',tr.hierarchy_Name),
ddo.hierarchy_Code,
#CONCAT(YEAR(a.voucher_date),'/',MONTH(a.voucher_date)),
a.bill_number, a.bill_date, a.total_allowance, #a.total_deduction, a.total_net_amount,
a.voucher_number, date(a.voucher_date), ben.beneficiary_name,
ben.beneficiary_code, ben.beneficiary_bank_account, ben.beneficiary_bank_ifsc,
ben.allowance, ben.allowance
#COUNT(a.voucher_number), 
#ROUND(SUM(a.total_allowance)/100000,2),
#ROUND(SUM(a.total_allowance)/100000,2)  
FROM ctmis_master.bill_details_base a
LEFT JOIN pfmaster.hierarchy_setup dep
	ON a.department_id = dep.hierarchy_Id
	AND dep.category = 'D'
LEFT JOIN pfmaster.hierarchy_setup tr
	ON a.treasury_id = tr.hierarchy_Id
	AND tr.category = 'T'
LEFT JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_id = ddo.hierarchy_Id
JOIN ctmis_master.bill_details_beneficiary ben
	ON a.id = ben.bill_base
WHERE
DATE(a.voucher_date) BETWEEN '2023-04-01'
	AND '2024-03-31'
AND a.sub_type = 'MR_MR'
#GROUP BY 
#concat(tr.hierarchy_Code,'->',tr.hierarchy_Name),
#concat(dep.hierarchy_Code,'->',dep.hierarchy_Name),
#CONCAT(YEAR(a.voucher_date),'/',MONTH(a.voucher_date))
ORDER BY 1,2,3,10
