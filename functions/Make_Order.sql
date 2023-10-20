/*Функция позволяет создать заказ(связана с delivery)*/
CREATE OR REPLACE FUNCTION make_order1(i_dish_quantity INT, i_user_id INT, i_dish_id INT, i_method_id INT, i_restaurant_id INT, i_app_time INT) RETURNS VOID AS $$
DECLARE
    order_id INT;
    i_delivery_id INT;
    total_price DECIMAL;
BEGIN
    IF NOT EXISTS(SELECT 1 FROM restaurant WHERE restaurant.restaurant_id = i_restaurant_id) THEN
        RAISE EXCEPTION 'Restaurant with id % does not exist', i_restaurant_id;
    END IF;
    order_id := floor(random() * 900000) + 100000;
    i_delivery_id := floor(random() * 900000) + 100000;
    SELECT dish_price * i_dish_quantity INTO total_price FROM dishes WHERE dish_id = i_dish_id;
    INSERT INTO delivery(delivery_id) VALUES (i_delivery_id);
    INSERT INTO clientorder(dish_quantity, payment_status, total_price, order_status, order_id, creation_time, method_id, user_id, restaurant_id, dish_id, delivery_id, app_time)
        VALUES(i_dish_quantity, 'pending', total_price, 'new', order_id, NOW(), i_method_id, i_user_id, i_restaurant_id, i_dish_id, i_delivery_id, i_app_time);
END;
$$ LANGUAGE plpgsql;
