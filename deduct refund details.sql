SET @cdate= '2025-01-01';
(
SELECT 'Major Head - 0049', 
concat(mh.head_code,'->',mh.head_name) "Major Head",
SUBSTR(h.head,1,11) "Head",
a.source_type "Source Type",
a.challan_date "Challan Date",
a.challan_number "Challan Number", 
YEAR(a.challan_date) "Year",MONTH(a.challan_date) "Month", 
a.department_name "Department", a.office_name "Office Name", 
a.type_of_payment "Type of Payment", a.remarks "Remarks", 
a.particulars "Particulars",
b.amount "Amount"
FROM ctmis_egras.receipt_base a
JOIN ctmis_egras.receipt_hoa_details b
	ON a.id = b.receipt_base
JOIN probityfinancials.heads h
	ON b.head_id = h.head_id
JOIN probityfinancials.head_setup mh
	ON h.major_head = mh.head_setup_id
WHERE
a.challan_date >= @cdate
AND h.head LIKE '0049%' 


UNION ALL 

SELECT 'Minor Head - 911' , 
concat(mh.head_code,'->',mh.head_name) "Major Head",
SUBSTR(h.head,1,11) "Head",
a.source_type "Source Type",
a.challan_date "Challan Date",
a.challan_number "Challan Number", 
YEAR(a.challan_date) "Year",MONTH(a.challan_date) "Month", 
a.department_name "Department", a.office_name "Office Name", 
a.type_of_payment "Type of Payment", a.remarks "Remarks", 
a.particulars "Particulars",
b.amount "Amount"
FROM ctmis_egras.receipt_base a
JOIN ctmis_egras.receipt_hoa_details b
	ON a.id = b.receipt_base
JOIN probityfinancials.heads h
	ON b.head_id = h.head_id
JOIN probityfinancials.head_setup mh
	ON h.major_head = mh.head_setup_id
WHERE
a.challan_date >= @cdate
AND substr(h.head,9,3) = '911'
)
ORDER BY 1,5 DESC 
