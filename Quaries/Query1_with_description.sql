SELECT
    client.client_name, client.client_surname,
    SUM (clientorder.dish_quantity) AS TotalQuantity
FROM
    client
JOIN
    clientorder ON client.user_id = clientorder.user_id 
GROUP BY
    client.client_name, client.client_surname;

/* 
Functionality: Shows total number of dishes, ordered per person
Who will use it: Customer Service Team: Knowing the quantity of dishes ordered by each client can help 
the customer service team better understand their preferences and history. 
This information can be used to provide personalized service and address any client-specific issues.
*/
