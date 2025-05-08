SELECT 
#a.id,b.name, 
ba.name "Bank",
t.name "Type", c.name "Category", st.state_description "State",
tr.hierarchy_Name "Treasury", DATE(a.voucher_date) "Date",
sum(a.total_allowance) "Gross" , SUM(a.total_deduction) "Deduction",
SUM(a.total_net_amount) "Net"
FROM ctmis_master.bill_details_base a
JOIN ctmis_dataset.bill_sub_type_master b
	ON a.sub_type = b.code
	AND b.type_master_code = 'PB'
JOIN pfmaster.hierarchy_setup tr
	ON a.treasury_id = tr.hierarchy_Id
	AND tr.category = 'T'
JOIN ctmis_dataset.pension_type_master t
	ON a.bill_pension_type = t.code 
JOIN ctmis_dataset.pension_category_type_master c
	ON a.bill_pension_category = c.code
JOIN ctmis_dataset.state_setup_master st
	ON a.state_code = st.state_code
JOIN ctmis_master.pension_bill_details pb
	ON a.id = pb.bill_details_base
JOIN ctmis_dataset.bank_branch_master br
	ON pb.bank_id = br.id
JOIN ctmis_dataset.bank_master ba
	ON br.bank_code = ba.code
WHERE
date(a.voucher_date) BETWEEN '2025-01-01' AND '2025-03-31'
AND a.approved_by IS NOT NULL 
#AND tr.hierarchy_Code = 'UDG'
GROUP BY # b.name, 
ba.name,
t.name, c.name, st.state_description,
tr.hierarchy_Name, DATE(a.voucher_date)
ORDER BY 6

