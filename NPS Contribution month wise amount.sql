SELECT tr.hierarchy_Name, 
concat(YEAR(a.voucher_date),'/',MONTH(a.voucher_date)), 
case 
	when a.head_id = 69212 then 'Employee Contribution'
	when a.head_id = 86597 then 'Govt. Contribution'
END AS ctype	, 
round(SUM(a.total_allowance)/10000000,2) FROM ctmis_master.bill_details_base a
JOIN pfmaster.hierarchy_setup tr
	ON a.treasury_id = tr.hierarchy_Id
WHERE
a.sub_type = 'MISC_NSDL'
#AND a.voucher_date IS NOT NULL 
GROUP BY tr.hierarchy_Name,
concat(YEAR(a.voucher_date),'/',MONTH(a.voucher_date)), case 
	when a.head_id = 69212 then 'Employee Contribution'
	when a.head_id = 86597 then 'Govt. Contribution'
END
#LIMIT 0,10
