SELECT
case 
	when a.total_allowance < 100000 
		then '1. Below 1 Lakh' 
	when a.total_allowance >= 100000 
	AND a.total_allowance < 200000 
		then '2. Below 2 Lakh'
	when a.total_allowance >= 200000 
	AND a.total_allowance < 300000 
		then '3. Below 3 Lakh'
	when a.total_allowance >= 300000 
	AND a.total_allowance < 400000 
		then '4. Below 4 Lakh'
	when a.total_allowance >= 400000
		then '5. Above 4 Lakh'
END AS amount, b.name, 
COUNT(*), round(SUM(a.total_allowance)/100000,2)
FROM ctmis_master.bill_details_base a
JOIN ctmis_dataset.bill_sub_type_master b
	ON a.sub_type = b.code
WHERE
a.type = 'GS'
AND a.approved_by IS NOT NULL 
AND date(a.voucher_date) BETWEEN 
	'2020-04-01' AND '2021-03-31'  
GROUP BY b.name,
case 
	when a.total_allowance < 100000 
		then '1. Below 1 Lakh' 
	when a.total_allowance >= 100000 
	AND a.total_allowance < 200000 
		then '2. Below 2 Lakh'
	when a.total_allowance >= 200000 
	AND a.total_allowance < 300000 
		then '3. Below 3 Lakh'
	when a.total_allowance >= 300000 
	AND a.total_allowance < 400000 
		then '4. Below 4 Lakh'
	when a.total_allowance >= 400000
		then '5. Above 4 Lakh'
END
ORDER BY 2,1