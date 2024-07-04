SELECT a.* , '---', b.*, '----', c.*
FROM ctmis_master.bills_nps_contribution_details a
JOIN ctmis_master.bills_nps_contribution_base b
	ON a.bill_nps_contribution_base_id = b.id
JOIN ctmis_master.bills_nps_deduction c
	ON a.bill_nps_deduction_id = c.id
WHERE 
date(a.entry_date) >= '2024-06-25'
ORDER BY a.id DESC
#LIMIT 0,20