SELECT d.hierarchy_Code, h.head, 
a.proposal_no, a.fs_issue_no,
date(a.issued_on), (a.amount*100000), ddo.hierarchy_Code
FROM probityfinancials.financial_sanction a
JOIN pfmaster.hierarchy_setup dep
	ON a.dept_id = dep.hierarchy_Id
JOIN probityfinancials.financial_sanction_heads he
	ON a.sanction_id = he.sanction_id
JOIN probityfinancials.heads h
	ON he.head_id = h.head_id
JOIN probityfinancials.head_setup dh
	ON h.detailed_head = dh.head_setup_id
LEFT JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_id = ddo.hierarchy_Id
JOIN pfmaster.seat_user_alloted c
	ON a.issued_by = c.allot_Id
JOIN pfmaster.hierarchy_setup d
	ON c.seat_Id = d.hierarchy_Id
WHERE
a.fin_year = '2024-25'
AND dep.hierarchy_Code = '07'
AND a.issued_by IS NOT NULL 
AND dh.head_code IN ('04','05','26')
AND (
	h.head LIKE '2053-00-093-0239%'
	OR 
	h.head LIKE '2053-00-093-0422%'
	OR 
	h.head LIKE '2070-00-115-0105%'
	)
AND substr(h.head,22,5) NOT IN ('04-01','04-02','04-03')
AND NOT EXISTS
(
	SELECT m.* FROM ctmis_master.bill_details_base m
	WHERE 
	a.fs_issue_no = m.sanction_number
	AND m.voucher_id IS NOT NULL 
)
AND NOT EXISTS
(
	SELECT m.* FROM ctmis_master.bill_details_base m
	WHERE 
	a.sanction_id = m.fs_id
	AND m.voucher_id IS NOT NULL 
)
AND a.proposal_no = 'FS-07-2024-25-02973'
ORDER BY 2, 5