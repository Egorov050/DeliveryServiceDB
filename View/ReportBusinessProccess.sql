Макс✌️, [20 окт. 2023 г., 20:40:35]:
CREATE VIEW editable_client_phone_view AS
SELECT user_id, client_phone
FROM client
WITH CHECK OPTION;

CREATE VIEW delivery_report AS
SELECT
    c.user_id,
    c.client_name,
    c.client_surname,
    co.order_id,
    co.creation_time,
    co.dish_quantity,
    co.order_status AS order_status,
    cc.card_num,
    cc.card_date,
    cc.card_type,
    d.delivery_id,
    cou.courier_name,
    ad.address_id,
    addr.user_address,
    co.order_status AS delivery_status,
    di.dish_id,
    di.dish_name,
    dc.dish_cat_id AS dish_category_id,
    di.dish_price,
    r.restaurant_id,
    r.restaurant_name,
    r.rest_address_id,
    ra.rest_address_name AS rest_location,
    dc.dish_cat_name AS dish_category_name
FROM
    client AS c
    JOIN clientorder AS co ON c.user_id = co.user_id
    JOIN card_of_client AS coc ON c.user_id = coc.user_id
    JOIN client_cards AS cc ON cc.card_num = coc.card_num
    JOIN delivery AS d ON co.delivery_id  = d.delivery_id
    JOIN dishes AS di ON di.dish_id = co.dish_id
    JOIN dish_menu AS dm ON di.dish_id = dm.dish_id
    join restaurant r on r.restaurant_id = co.restaurant_id
    JOIN dish_cat AS dc ON di.dish_cat_id  = dc.dish_cat_id
    JOIN rest_address AS ra ON r.rest_address_id = ra.rest_address_id
    join courier as cou on cou.courier_id = d.courier_id
    join adress_of_client as ad on ad.user_id = c.user_id 
    join address as addr on addr.address_id = ad.address_id;
