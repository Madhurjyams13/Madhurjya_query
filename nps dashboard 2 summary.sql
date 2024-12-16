SELECT o.tr "Treasury",
concat(o.year,''), concat(o.month,''), 
o.uploaded "Uploaded (A)" ,
o.No_PRAN "No PRAN (B)",
o.Confirmation_Awaiting "Confirmation Awaiting (C)",
o.Error_in_Upload "Error in Upload (D)",
o.Not_Uploaded "Not Uploaded (E)",
o.others "Others (F)",
o.uploaded + o.No_PRAN + o.Confirmation_Awaiting +
o.Error_in_Upload + o.Not_Uploaded + o.others "Total",

o.uploaded + o.Confirmation_Awaiting + o.Not_Uploaded "Eligible for Upload (T=A+C+E)" ,
ROUND((o.uploaded / (o.uploaded + o.Confirmation_Awaiting + o.Not_Uploaded))*100,2) "Upload % (A/T)"
#,o.*
FROM 
(
	SELECT 
	    n.tr,
	    n.year,
	    n.month,
	    COUNT(CASE WHEN n.upload_status = 'Uploaded' THEN 1 END) AS Uploaded,
	    COUNT(CASE WHEN n.upload_status = 'No PRAN' THEN 1 END) AS No_PRAN,
	    COUNT(CASE WHEN n.upload_status = 'Confirmation Awaiting' THEN 1 END) AS Confirmation_Awaiting,
	    COUNT(CASE WHEN n.upload_status = 'Error in Upload' THEN 1 END) AS Error_in_Upload,
	    COUNT(CASE WHEN n.upload_status = 'Not Uploaded' THEN 1 END) AS Not_Uploaded,
	    COUNT(CASE WHEN n.upload_status = 'Others' THEN 1 END) AS Others
	FROM 
	(
	    SELECT 
	        m.tr, 
	        m.year, 
	        m.month, 
	        m.upload_status, 
	        m.id
	    FROM 
	    (
	        SELECT 
	            tr.hierarchy_Name AS tr, 
	            a.year, 
	            a.month,
	            CASE 
	                WHEN a.status = 'A' THEN 'Uploaded'
	                WHEN a.status = 'N' THEN 'No PRAN'
	                WHEN a.status = 'I' THEN 'Confirmation Awaiting'
	                WHEN a.status = 'P' AND NOT EXISTS 
	                (
	                    SELECT 1 
	                    FROM ctmis_master.bills_nps_contribution_details n
	                    WHERE a.id = n.bill_nps_deduction_id
	                ) THEN 'Not Uploaded'
	                WHEN a.status = 'P' AND EXISTS 
	                (
	                    SELECT 1 
	                    FROM ctmis_master.bills_nps_contribution_details n
	                    WHERE a.id = n.bill_nps_deduction_id
	                    AND n.status = 'Rejected'
	                ) THEN 'Error in Upload'
	                ELSE 'Others'
	            END AS upload_status,
	            a.id
	        FROM ctmis_master.bills_nps_deduction a
	        JOIN pfmaster.hierarchy_setup tr
	            ON a.treasury_id = tr.hierarchy_Id
	            AND tr.category = 'T'
	        WHERE a.year >= 2024
	        AND a.type = 'R'
	    ) m
	) n
	GROUP BY 
	    n.tr, 
	    n.year, 
	    n.month
) o
ORDER BY 
    o.tr, 
   concat(o.year,''), concat(o.month,'')