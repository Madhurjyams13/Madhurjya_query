SELECT DATE_FORMAT(m.ret_date, '%Y/%m'), COUNT(*) 
#m.* 
FROM 
(
	SELECT str_to_date(a.dob,'%d-%m-%Y') dob_date,
	#COUNT(*) #str_to_date(a.dob,'%d-%m-%Y'),
	case 
		when DAY(str_to_date(a.dob,'%d-%m-%Y')) = 1 
			then ( str_to_date(a.dob,'%d-%m-%Y') - INTERVAL 1 DAY ) + INTERVAL 60 YEAR 
		ELSE ( LAST_DAY(str_to_date(a.dob,'%d-%m-%Y')) + INTERVAL 60 YEAR )
	END AS ret_date,
	a.* 
	FROM probityfinancials.eis_data a
	WHERE
	a.removed_by_ddo = 'N' 
	AND a.dob IS NOT NULL
	#AND str_to_date(a.dob,'%d-%m-%Y') BETWEEN '1964-03-02' AND '1964-04-01' 
	#AND DAY(a.dob) = 1
	#ORDER BY a.id DESC
) m
GROUP BY DATE_FORMAT(m.ret_date, '%Y/%m')
ORDER BY 1 DESC 
#LIMIT 0,20
