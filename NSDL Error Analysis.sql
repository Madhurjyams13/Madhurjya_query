SELECT a.error_description "Error Details", 
SUBSTR(a.error_description,1,137) "Error Group",
tr.hierarchy_Code "Treasury Code", 
tr.hierarchy_Name "Treasury Name", 
ddo.hierarchy_Code "DDO Code", c.ppan "PPAN", c.pran "PRAN",
c.year, c.month, c.employee_contribution "Emp Contri", 
c.employer_contribution "Gov Contri",
case
	when c.status = 'A' then 'Uploaded'
	when c.status = 'P' then 'Pending'
	ELSE c.status
END AS Cuurent_Status
FROM ctmis_master.nps_nsdl_fvu_error a
JOIN ctmis_master.bills_nps_contribution_details b
	ON a.bills_nps_contribution_details = b.id
JOIN ctmis_master.bills_nps_deduction c
	ON b.bill_nps_deduction_id = c.id
JOIN pfmaster.hierarchy_setup tr
	ON c.treasury_id = tr.hierarchy_Id
	AND tr.category = 'T'
JOIN pfmaster.hierarchy_setup ddo
	ON c.ddo_id = ddo.hierarchy_Id
	AND ddo.category = 'S'
WHERE
upper(a.error_warning) = 'ERROR'
#AND a.error_description LIKE '%already%'
