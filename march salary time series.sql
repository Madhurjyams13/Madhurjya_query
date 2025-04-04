SELECT 
SUBSTR(h.head,22,2),
YEAR(a.voucher_date), MONTH(a.voucher_date),
round(SUM(a.total_allowance-a.total_deduction)/10000000,2) "Amount in Cr"
FROM 
 ctmis_master.bill_details_base a
JOIN probityfinancials.heads h
	ON a.head_id = h.head_id
WHERE
date(a.voucher_date) BETWEEN '2023-04-01' AND '2025-02-28'
AND SUBSTR(h.head,22,2) IN ('01','02','31')
GROUP BY 
SUBSTR(h.head,22,2),
YEAR(a.voucher_date), MONTH(a.voucher_date)
ORDER BY 1,2,3