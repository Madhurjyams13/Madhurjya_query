SELECT 
    ds.district_Name,
    t.hierarchy_Name "Treasury Name",
    hs.hierarchy_Code,
    o.office_Name,
    us.title_Name,
    us.user_Name,
    us.last_Name,
    us.email,
    us.mobile
FROM
    pfmaster.hierarchy_setup AS hs
    	  JOIN pfmaster.hierarchy_setup o
    ON hs.parent_hierarchy = o.hierarchy_Id
        JOIN
    probityfinancials.ddo_setup AS s ON s.ddo_id = hs.hierarchy_Id
        JOIN
    probityfinancials.district_setup AS ds ON ds.district_Id = s.district_id
        JOIN
    pfmaster.hierarchy_setup AS t ON t.hierarchy_Id = s.treasury_id
        JOIN
    pfmaster.seat_user_alloted AS sua ON sua.seat_id = hs.hierarchy_Id
        JOIN
    pfmaster.user_setup AS us ON us.user_Id = sua.user_Id
WHERE
    hs.category = 'S'
    AND sua.active_Status = 'Y'
    AND hs.hierarchy_Code = 'DIS/AAT/001'
    /*AND EXISTS (	
			SELECT b.* 
			FROM ctmis_master.bill_details_base b 
			WHERE
			b.sub_type = 'SB_SB'
			AND b.pay_year = 2024
			AND b.pay_month >= 4
			AND hs.hierarchy_Id = b.ddo_id	
			)
    */
    ORDER BY 1,2,3