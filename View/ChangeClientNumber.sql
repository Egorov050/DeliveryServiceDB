/*Gives an opportunity to change the phone number*/
CREATE VIEW editable_client_phone_view AS
SELECT user_id, client_phone
FROM client
WITH CHECK OPTION;
