SELECT tr.hierarchy_Code, tr.hierarchy_Name, a.nps_contribution_number, a.file_status,# b.status,
c.month , c.year, COUNT(*), SUM(c.employee_contribution),SUM(c.employer_contribution)
FROM ctmis_master.bills_nps_contribution_base a
JOIN pfmaster.hierarchy_setup tr
	ON a.treasury_id = tr.hierarchy_Id
	AND tr.category = 'T'
JOIN ctmis_master.bills_nps_contribution_details b
	ON a.id = b.bill_nps_contribution_base_id
JOIN ctmis_master.bills_nps_deduction c
	ON b.bill_nps_deduction_id = c.id
WHERE
date(a.entry_date) >= '2024-08-20'
GROUP BY tr.hierarchy_Code, tr.hierarchy_Name, a.nps_contribution_number, a.file_status,#b.status,
c.month , c.year