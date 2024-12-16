SELECT DATE(b.payment_processed_on) "Transaction Date",
SUBSTR(h.head,22,2) "Detail Head", 
COUNT(c.bill_number) "No of Bills",
round(SUM(c.total_allowance)/10000000,2) "Gross in Cr",
round(SUM(a.net_amount)/10000000,2) "Net in Cr"
FROM ctmis_master.payment_bills a
JOIN ctmis_master.payment_base b
	ON a.payment_base_id = b.id
JOIN ctmis_master.bill_details_base c
	ON a.bill_details_base_id = c.id
JOIN probityfinancials.heads h
	ON c.head_id = h.head_id
WHERE
DATE(b.payment_processed_on) >= '2024-10-28'
#AND c.pay_year = 2024 AND c.pay_month = 10
AND SUBSTR(h.head,22,2) IN ('01','02')
GROUP BY SUBSTR(h.head,22,2), 
DATE(b.payment_processed_on)
#ORDER BY b.id DESC 