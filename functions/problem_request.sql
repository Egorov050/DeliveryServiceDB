/*<функция позволяет отправлять запросы на решение ошибок. Сотрудник службы поддержки выбирается рандомно >*/
CREATE OR REPLACE FUNCTION insert_problem_request(
    p_issue_id INT,
    p_user_id INT
) RETURNS VOID AS $$
DECLARE
    v_request_id INT;
    v_employee_id INT;
BEGIN
    v_request_id := floor(random() * 900000) + 100000;
    v_employee_id := floor(random() * 99) + 1;

    INSERT INTO problem_request (request_id, employee_id, issue_id, user_id, date_of_request, status)
    VALUES (v_request_id, v_employee_id, p_issue_id, p_user_id, CURRENT_DATE, 'accepted');
END;
$$ LANGUAGE plpgsql;
