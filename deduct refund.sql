SELECT 'Major Head - 0049' , DATE(a.challan_date) "Challan Date", 
#SUBSTR(h.head,1,11) "Head", 
#YEAR(a.challan_date) "Year" ,MONTH(a.challan_date) "Month", 
SUM(b.amount) "Amount in Rs"
FROM ctmis_egras.receipt_base a
JOIN ctmis_egras.receipt_hoa_details b
	ON a.id = b.receipt_base
JOIN probityfinancials.heads h
	ON b.head_id = h.head_id
WHERE
a.challan_date >= '2025-03-01'
AND h.head LIKE '0049%'
GROUP BY 
#SUBSTR(h.head,1,11), YEAR(a.challan_date),MONTH(a.challan_date)
DATE(a.challan_date)


UNION ALL 

SELECT 'Minor Head - 911', DATE(a.challan_date),
#SUBSTR(h.head,1,11), 
#YEAR(a.challan_date),MONTH(a.challan_date), 
SUM(b.amount) 
FROM ctmis_egras.receipt_base a
JOIN ctmis_egras.receipt_hoa_details b
	ON a.id = b.receipt_base
JOIN probityfinancials.heads h
	ON b.head_id = h.head_id
WHERE
a.challan_date >= '2025-03-01'
AND substr(h.head,9,3) = '911'
GROUP BY DATE(a.challan_date)
#SUBSTR(h.head,1,11),YEAR(a.challan_date),MONTH(a.challan_date)
ORDER BY 1,2
#1,2,3,4