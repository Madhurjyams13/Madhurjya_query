SELECT mo.module_Name, smo.name sub_module, r.page_Title page_title, r.ticket_No , 
r.controlling_Office, r.hierarchy_Code, r.seat_Name,
r.category, r.severity, r.priority, r.request_Type,
r.status,
case 
	when  r.status = 'N' then 'Not submitted'
	when  r.status = 'S' then 'Submitted'
	when  r.status = 'V' then 'Verified'
	when  r.status = 'A' then 'Accepted'
	when  r.status = 'C' then 'Closed'
	when  r.status = 'R' then 'Rejected'
	ELSE  r.status
END AS STATUS1,
r.submitted_On, 
acceptk.name accepted_by,
TIMESTAMPDIFF(HOUR, r.submitted_On, ifnull(r.accept_Or_Reject_On, NOW()) ) accept_time_hour,
r.accept_Or_Reject_On,
assignk.name assigned_to, 
tsk.completedDate,
TIMESTAMPDIFF(HOUR, ifnull(r.accept_Or_Reject_On, NOW()), ifnull(r.closed_On, NOW() ) ) closed_time_hour,
r.closed_On,
closedk.name closed_by
FROM helpdesk.request r
JOIN helpdesk.module mo
	ON r.module_Id = mo.id
LEFT JOIN helpdesk.sub_module_setup smo
	ON r.sub_module_id = smo.id
LEFT JOIN helpdesk.task tsk
	ON r.id = tsk.request_Id
	
LEFT JOIN helpdesk.ts_km_mapping accept
	ON r.accept_Or_Reject_By = accept.id 
LEFT JOIN helpdesk.km_user acceptk
	ON accept.km_User_Id = acceptk.id
	
LEFT JOIN helpdesk.ts_km_mapping assign
	ON r.assigned_To = assign.id 
LEFT JOIN helpdesk.km_user assignk
	ON assign.km_User_Id = assignk.id
	
LEFT JOIN helpdesk.ts_km_mapping closed
	ON r.closed_By = closed.id 
LEFT JOIN helpdesk.km_user closedk
	ON closed.km_User_Id = closedk.id
WHERE r.fin_Year = '2024-25'
AND r.submitted_On IS NOT NULL 

ORDER BY r.submitted_On LIMIT 0,20