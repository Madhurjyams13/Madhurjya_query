SELECT
	 'Salary',
    a.bill_number,
    a.bill_date,
    d.created_on,
    a.received_on,
    a.accepted_on,
    a.approved_on,
    a.payment_scroll_generated_on,
    c.payment_acknowledgement_received_on,
    COUNT(b.beneficiary_id),
    TIMESTAMPDIFF(MINUTE, d.created_on, a.received_on) AS create_to_received_minutes,
    TIMESTAMPDIFF(MINUTE, a.received_on, a.accepted_on) AS received_to_accepted_minutes,
    TIMESTAMPDIFF(MINUTE, a.accepted_on, a.approved_on) AS accepted_to_approved_minutes,
    TIMESTAMPDIFF(MINUTE, a.approved_on, a.payment_scroll_generated_on) AS approved_to_scroll_minutes,
    TIMESTAMPDIFF(MINUTE, a.payment_scroll_generated_on, c.payment_acknowledgement_received_on) AS scroll_to_acknowledgement_minutes
FROM
    ctmis_master.bill_details_base a
JOIN
    ctmis_master.bill_details_beneficiary b ON a.id = b.bill_base
LEFT JOIN
    ctmis_master.payment_bills c ON a.id = c.bill_details_base_id
RIGHT JOIN
    pfpaybills.salary d ON a.source_bill_id = d.salary_id
WHERE
    a.sub_type IN ('SB_SB')
    AND a.rejected_by IS NULL
    AND DATE(d.created_on) >= '2025-01-25'
GROUP BY
a.bill_number,
    a.bill_date,
    d.entry_date,
    a.received_on,
    a.accepted_on,
    a.approved_on,
    a.payment_scroll_generated_on,
    c.payment_acknowledgement_received_on,
    TIMESTAMPDIFF(MINUTE, d.created_on, a.received_on) ,
    TIMESTAMPDIFF(MINUTE, a.received_on, a.accepted_on) ,
    TIMESTAMPDIFF(MINUTE, a.accepted_on, a.approved_on) ,
    TIMESTAMPDIFF(MINUTE, a.approved_on, a.payment_scroll_generated_on) ,
    TIMESTAMPDIFF(MINUTE, a.payment_scroll_generated_on, c.payment_acknowledgement_received_on)
ORDER BY
    d.entry_date DESC	 
	 ;