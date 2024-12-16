SELECT 
concat(mh.head_code,' -> ', mh.head_name),
concat(smh.head_code,' -> ', smh.head_name),
concat(minh.head_code,' -> ', minh.head_name),
YEAR(a.receipt_date), 
MONTH(a.receipt_date),
a.source_category,
round(SUM(a.amount)/10000000,2)
FROM ctmis_accounts.ledger_receipts a
JOIN probityfinancials.heads h
	ON a.head_of_account = h.head_id
JOIN probityfinancials.head_setup mh
	ON h.major_head = mh.head_setup_id
JOIN probityfinancials.head_setup smh
	ON h.sub_major_head = smh.head_setup_id
JOIN probityfinancials.head_setup minh
	ON h.minor_head = minh.head_setup_id
WHERE
DATE(a.receipt_date) >= '2024-04-01'
AND CAST(mh.head_code AS INTEGER) >= 8000
GROUP BY 
concat(mh.head_code,' -> ', mh.head_name),
concat(smh.head_code,' -> ', smh.head_name),
concat(minh.head_code,' -> ', minh.head_name),
YEAR(a.receipt_date), 
MONTH(a.receipt_date),
a.source_category
ORDER BY 1,2,3,4,5,6
