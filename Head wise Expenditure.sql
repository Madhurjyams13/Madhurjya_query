SELECT concat(m.head, '-', m.scheme, '-', m.ga) head, 
MAX( case when m.mm = 1 then m.gross END) AS Jan,
MAX( case when m.mm = 2 then m.gross END) AS Feb,
MAX( case when m.mm = 3 then m.gross END) AS Mar
FROM 
(

	SELECT h.head, 
	CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'EE'
	END AS scheme,
	concat(h.ga_ssa_status,'-',h.voted_charged_status) ga,
	MONTH(b.approved_on) mm, SUM(b.total_allowance) gross
	FROM ctmis_accounts.ledger_expenditure le
	LEFT JOIN probityfinancials.heads h 
		ON le.head_of_account = h.head_id 
	JOIN ctmis_master.bill_details_base b
		ON le.source_reference = b.id
	LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
		ON	h.head_id = pchm.head_id
	LEFT JOIN probityfinancials.plan_category pc 
	ON	pchm.pc_id = pc.pc_id
	WHERE
	date(b.approved_on) BETWEEN DATE('2024-01-01') AND DATE('2024-03-31')
	AND h.head LIKE '2056%'
	GROUP BY h.head, MONTH(b.approved_on),
	CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'EE'
	END

) m 
GROUP BY concat(m.head, '-', m.scheme, '-', m.ga)
ORDER BY 1