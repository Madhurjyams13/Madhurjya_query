SELECT m.head, m.dep, YEAR(m.receipt_date), 
MONTH(m.receipt_date),
m.mode, SUM(m.amount)
FROM 
(
	SELECT 
	substr(h.head,1,16) head,
	dep.hierarchy_Name dep,
	case 
		when a.source_category = 'EXCEL' 
		AND d.challan_number LIKE '100%'
			then 'SBI EPAY'
		when a.source_category = 'EXCEL' 
		AND d.challan_number NOT LIKE '100%'
			then 'SBI POS'
		ELSE a.source_category
	END AS MODE, tr.hierarchy_Name tr_name,
	a.receipt_date, a.amount, a.who_deposited, 
	a.for_whom_deposited, d.challan_number, d.challan_date,
	d.bank_name
	#a.*, '----', d.*
	FROM ctmis_accounts.ledger_receipts a
	JOIN probityfinancials.heads h
		ON a.head_of_account = h.head_id
	JOIN ctmis_egras.receipt_base d
		ON a.source_reference = d.id
	JOIN pfmaster.hierarchy_setup tr
		ON a.treasury = tr.hierarchy_Id
		AND tr.category = 'T'
	LEFT JOIN pfmaster.hierarchy_setup dep
		ON a.department = dep.hierarchy_Id
		AND dep.category = 'D'
	WHERE 
	date(a.receipt_date) BETWEEN '2024-04-01' AND '2024-06-30'
	AND ( h.head LIKE '0022%' 
			OR h.head LIKE '0028%'
			OR h.head LIKE '0029%'
			OR h.head LIKE '0040%'
			OR h.head LIKE '0042%'
			OR h.head LIKE '0043%'
			OR h.head LIKE '0045%'  
		 )
	#AND a.source_category NOT IN ('MANUAL')
	#AND d.challan_number LIKE '100%'
	#ORDER BY a.id DESC 
	#LIMIT 0,5
) m

GROUP BY m.head, YEAR(m.receipt_date), 
MONTH(m.receipt_date),
m.mode, m.dep
ORDER BY 1,3,4,2