SELECT concat(mh.head_code,'->',mh.head_name) "Head",
a.source_type "Source", 
year(a.entry_date)  "Year",
month(a.entry_date)  "Month",
SUM(a.total_receipt) "Amount in Rs", 
round(SUM(a.total_receipt)/10000000,2) "Amount in Cr"
FROM ctmis_egras.receipt_base a
JOIN ctmis_egras.receipt_hoa_details b
	ON a.id = b.receipt_base
JOIN probityfinancials.heads h
	ON b.head_id = h.head_id
JOIN probityfinancials.head_setup mh
	ON h.major_head = mh.head_setup_id
WHERE
CAST(mh.head_code AS UNSIGNED) BETWEEN 48 AND 2000
AND date(a.entry_date) >= '2024-04-01'
GROUP BY concat(mh.head_code,'->',mh.head_name),
a.source_type, 
year(a.entry_date) ,
month(a.entry_date)
ORDER BY 3,4,1,2
