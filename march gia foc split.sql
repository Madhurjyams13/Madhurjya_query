SELECT 
case
	when a.foc_number IS NULL 
		then 'Non-Foc'
	ELSE 
		'FoC'
END AS foc_status,
case 
when a.voucher_date  IS NOT NULL
then 'Payment Done'
	when a.approved_by IS NOT NULL 
		then 'Approved and yet to be Paid'
	when a.rejected_by IS NOT NULL 
		then 'Rejected'
	when a.approved_by IS NULL AND a.rejected_by IS NULL 
		then 'Processing at Treasury'
	ELSE 'Others'
END AS STATUS,		
case 
	when a.pay_year = 2025 AND a.pay_month = 2
		then 'Feb/2025'
	ELSE 'Others'
END AS period, 
COUNT(a.bill_number) "No of Bills",
round(SUM(a.total_allowance-a.total_deduction)/10000000,2) "Amount in Cr"
FROM 
 ctmis_master.bill_details_base a
JOIN probityfinancials.heads h
	ON a.head_id = h.head_id
WHERE
date(a.received_on) >= '2025-02-25'
AND SUBSTR(h.head,22,2) = '31'
GROUP BY 
case 
when a.voucher_date  IS NOT NULL
then 'Payment Done'
	when a.approved_by IS NOT NULL 
		then 'Approved and yet to be Paid'
	when a.rejected_by IS NOT NULL 
		then 'Rejected'
	when a.approved_by IS NULL AND a.rejected_by IS NULL 
		then 'Processing at Treasury'
	ELSE 'Others'
END ,
case 
	when a.pay_year = 2025 AND a.pay_month = 2
		then 'Feb/2025'
	ELSE 'Others'
END,
case
	when a.foc_number IS NULL 
		then 'Non-Foc'
	ELSE 
		'FoC'
END