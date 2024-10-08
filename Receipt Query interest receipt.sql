SELECT substr(h.head,1,11)  "Head",
a.source_type "Source", 
DATE(a.entry_date)  "Challan Date",
DATE(a.scroll_date) "Scroll Date", 
SUM(a.total_receipt) "Amount in Rs", 
round(SUM(a.total_receipt)/10000000,2) "Amount in Cr"
FROM ctmis_egras.receipt_base a
JOIN ctmis_egras.receipt_hoa_details b
	ON a.id = b.receipt_base
JOIN probityfinancials.heads h
	ON b.head_id = h.head_id
WHERE
(h.head LIKE '0049-04-800%' OR h.head LIKE '2202-01-911%')
AND date(a.entry_date) >= '2024-10-01'
#AND a.source_type = 'MANUAL'
GROUP BY substr(h.head,1,11), 
a.source_type, DATE(a.entry_date), DATE(a.scroll_date)
ORDER BY 1,2,3,4