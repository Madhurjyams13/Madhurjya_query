SELECT a.id, t.token, DATE(t.token_date), 'B', 
case 
	when st.designation = 'Dealing Assistant' then 1
	when st.designation = 'Accountant' then 2
	when wf.flow_type = 'APPROVE' then 4
	when st.designation = 'Treasury Officer' then 3
	ELSE 0
END AS PROCESSING_STAGE,
try.hierarchy_Code, 
SUBSTR(stg.head_of_account,1,4) MAJOR_HEAD,
case 
	when st.designation = 'Dealing Assistant' then 'DA'
	when st.designation = 'Accountant' then 'ACCT'
	when wf.flow_type = 'APPROVE' then 'CW'
	when st.designation = 'Treasury Officer' then 'TO'
END AS ROLE_ID, um.user_Name, um.user_Code, 
case 
	when st.designation = 'Dealing Assistant' then wf.entry_date
	when st.designation = 'Accountant' then wf.entry_date
	when wf.flow_type = 'APPROVE' then wf.processed_on
	when st.designation = 'Treasury Officer' then wf.entry_date
END AS PROCESS_DATE, 'O',
stg.ddo_code
#wf.entry_date, wf.processed_on
#, '-----', st.*, '------', um.*, '----------', hs.*
#,'------------',wf.* 
FROM ctmis_master.bill_details_base a 
JOIN ctmis_master.token_master t
	ON a.token_id = t.id	
JOIN pfmaster.hierarchy_setup try 
	ON a.treasury_id = try.hierarchy_Id
	AND try.category = 'T'
JOIN ctmis_master.bill_details_flow wf 
	ON a.id = wf.bill_base
JOIN pfmaster.seat_user_alloted st
	ON wf.to_seat = st.allot_Id
JOIN pfmaster.hierarchy_setup hs
	ON st.seat_Id = hs.hierarchy_Id
JOIN pfmaster.user_setup um
	ON st.user_Id = um.user_Id
LEFT JOIN ctmis_staging.staging_bill_details_base stg
	ON a.stager_id = stg.id		
WHERE
try.hierarchy_Code = 'KKJ'
AND DATE(a.token_date) >= '2023-11-28'
ORDER BY a.id DESC, wf.id 
