SELECT 
    m.assigned_to,
    COUNT(CASE WHEN m.module_Name = 'Budget Planning and Preparation' THEN m.ticket_No END) AS 'Budget Planning and Preparation Count',
    COUNT(CASE WHEN m.module_Name = 'Budget Allocation and Distribution' THEN m.ticket_No END) AS 'Budget Allocation and Distribution Count',
    COUNT(CASE WHEN m.module_Name = 'Cash Planning and Management' THEN m.ticket_No END) AS 'Cash Planning and Management Count',
    COUNT(CASE WHEN m.module_Name = 'Accounting and Reconciliation' THEN m.ticket_No END) AS 'Accounting and Reconciliation Count',
    COUNT(CASE WHEN m.module_Name = 'RIDF Loan Processing' THEN m.ticket_No END) AS 'RIDF Loan Processing Count',
    COUNT(CASE WHEN m.module_Name = 'Audit' THEN m.ticket_No END) AS 'Audit Count',
    COUNT(CASE WHEN m.module_Name = 'HelpDesk' THEN m.ticket_No END) AS 'HelpDesk Count',
    COUNT(CASE WHEN m.module_Name = 'General Requirements' THEN m.ticket_No END) AS 'General Requirements Count',
    COUNT(CASE WHEN m.module_Name = 'Reporting and Data Analytics' THEN m.ticket_No END) AS 'Reporting and Data Analytics Count',
    COUNT(CASE WHEN m.module_Name = 'Debt Management' THEN m.ticket_No END) AS 'Debt Management Count',
    COUNT(CASE WHEN m.module_Name = 'Stock Management' THEN m.ticket_No END) AS 'Stock Management Count',
    COUNT(CASE WHEN m.module_Name = 'Receipts Management' THEN m.ticket_No END) AS 'Receipts Management Count',
    COUNT(CASE WHEN m.module_Name = 'Expenditure Processing and Reporting' THEN m.ticket_No END) AS 'Expenditure Processing and Reporting Count',
    COUNT(CASE WHEN m.module_Name = 'Administrative Approval, Technical and Financial Sanctions' THEN m.ticket_No END) AS 'Administrative Approval, Technical and Financial Sanctions Count',
    COUNT(CASE WHEN m.module_Name = 'Bill Creation' THEN m.ticket_No END) AS 'Bill Creation Count',
    COUNT(CASE WHEN m.module_Name = 'Employee and Payroll' THEN m.ticket_No END) AS 'Employee and Payroll Count',
    COUNT(CASE WHEN m.module_Name = 'GPF Management' THEN m.ticket_No END) AS 'GPF Management Count',
    COUNT(CASE WHEN m.module_Name = 'Asset Registry' THEN m.ticket_No END) AS 'Asset Registry Count',
    COUNT(CASE WHEN m.module_Name = 'PFMS' THEN m.ticket_No END) AS 'PFMS Count',
    COUNT(CASE WHEN m.module_Name = 'Ceiling' THEN m.ticket_No END) AS 'Ceiling Count',
    COUNT(CASE WHEN m.module_Name = 'SNA SPARSH' THEN m.ticket_No END) AS 'SNA SPARSH Count'
FROM 
(
    SELECT 
        mo.module_Name, 
        IFNULL(
            CONCAT(assignu.user_Name, ' ', assignu.last_Name), 'UNASSIGNED'
        ) AS assigned_to,
        r.submitted_On, 
        r.accept_Or_Reject_On, 
        TIMESTAMPDIFF(HOUR, r.submitted_On, r.accept_Or_Reject_On) AS accp_a_subm,
        TIMESTAMPDIFF(HOUR, r.submitted_On, NOW()) AS pending_for,
        r.ticket_No
    FROM helpdesk.request r
    JOIN helpdesk.module mo
        ON r.module_Id = mo.id
    LEFT JOIN helpdesk.ts_km_mapping assign
        ON r.assigned_To = assign.id 
    LEFT JOIN pfmaster.seat_user_alloted assigns
        ON assign.pfmaster_Allot_Id = assigns.allot_Id
    LEFT JOIN pfmaster.user_setup assignu
        ON assigns.user_Id = assignu.user_Id
    WHERE
        r.fin_Year IN ('2024-25','2025-26')
        AND r.status NOT IN ('C', 'N')
) m
GROUP BY m.assigned_to
ORDER BY m.assigned_to;
