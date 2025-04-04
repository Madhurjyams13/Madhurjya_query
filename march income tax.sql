SELECT
case 
	when SUBSTR(h.head,22,2) IN ('01','02','31')
		then	'Salary (01,02,31)'
	ELSE 'Non Salary'
END AS "Detail Head",
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
round(SUM(c.amount)/10000000,2) "Income Tax in Cr"
FROM 
 ctmis_master.bill_details_base a
JOIN probityfinancials.heads h
	ON a.head_id = h.head_id
JOIN ctmis_master.bill_details_component c
	ON a.id = c.bill_base
JOIN ctmis_dataset.bill_component_master cm
	ON c.component_master = cm.code
	AND cm.component_code IN ('TIT','ITFR')
WHERE
date(a.received_on) >= '2025-02-25'
GROUP BY 
case 
	when SUBSTR(h.head,22,2) IN ('01','02','31')
		then	'Salary (01,02,31)'
	ELSE 'Non Salary'
END,
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
END,
case 
	when a.pay_year = 2025 AND a.pay_month = 2
		then 'Feb/2025'
	ELSE 'Others'
END
