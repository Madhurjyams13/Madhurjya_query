SELECT 
p.id, p.bill_details_base_id,
a.id,
b.name, ba.name,
t.name, c.name, st.state_description,
a.total_allowance, a.total_deduction,
tr.hierarchy_Name, DATE(a.voucher_date),
a.bill_number, a.bill_date
FROM ctmis_master.bill_details_base a
JOIN ctmis_dataset.bill_sub_type_master b
	ON a.sub_type = b.code
	AND b.type_master_code = 'PB'
JOIN pfmaster.hierarchy_setup tr
	ON a.treasury_id = tr.hierarchy_Id
	AND tr.category = 'T'
LEFT JOIN ctmis_dataset.pension_type_master t
	ON a.bill_pension_type = t.code 
LEFT JOIN ctmis_dataset.pension_category_type_master c
	ON a.bill_pension_category = c.code
LEFT JOIN ctmis_dataset.state_setup_master st
	ON a.state_code = st.state_code
LEFT JOIN ctmis_master.payment_bills p
	ON a.id = p.bill_details_base_id
LEFT JOIN ctmis_master.pension_bill_details pb
	ON a.id = pb.bill_details_base
LEFT JOIN ctmis_dataset.bank_branch_master br
	ON pb.bank_id = br.id
LEFT JOIN ctmis_dataset.bank_master ba
	ON br.bank_code = ba.code
WHERE
date(a.voucher_date) BETWEEN '2025-02-01' AND '2025-02-28'
ORDER BY 6

