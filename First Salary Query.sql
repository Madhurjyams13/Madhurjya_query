SELECT concat(YEAR(m.bdate),'/',MONTH(m.bdate)), COUNT(m.ppan) FROM 
(
	SELECT a.gpf_or_ppan_no ppan, MIN(c.bill_date) bdate
	FROM probityfinancials.eis_data a
	JOIN pfpaybills.salary_allowances b
		ON a.id = b.eis_id
	JOIN pfpaybills.salary c
		ON b.salary_id = c.salary_id
	WHERE
	DATE(a.appoin_Date) >= '2023-06-01' 
	AND LENGTH(a.gpf_or_ppan_no) = 16
	GROUP BY a.gpf_or_ppan_no
) m
GROUP BY concat(YEAR(m.bdate),'/',MONTH(m.bdate))
ORDER BY 1