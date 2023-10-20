/*
Изначально все создается в табличке <request_registration_rest>. Туда подтягиваются все данные о ресторане. Причем все 
данные подтягиваются именно к тому человеку, который создал запрос. Если попытаться добавить данные к человеку, которого там нет, 
в нашем случае это <id>, то выдаст ошибку и не даст добавить данные. Также данные вносятся автоматически сразу в таблицы, показывающие информацию
о ресторане, его адрес и тд. В <request_registration_rest> есть только id всех данных <id_restaurant_info> например. Затем, когда мы 
запускаем финальную функцию <add_rest>, она добавляет все данные в табличку <restaurant>. 
*/
/*Эта функция создает юзера, который делает запрос на добавление ресторана. Делается первой*/
create or replace function add_user1(
	user_id1 int
)  RETURNS VOID AS $$
begin
	insert into request_registration_rest(clientt_id) values (user_id1);
end;
$$ LANGUAGE plpgsql;


/*Эта функция добаляет информацию о ресторане*/
create or replace function add_rest_info1 (
   i_id int,
   i_info_rest_raiting int,
   i_info_rest_cuisine char, 
   i_info_rest_work_hours char, 
   i_rest_itn int, 
   i_rest_legal_address char, 
   i_rest_bank_account char, 
   i_mean_delivery_time int)  RETURNS VOID AS $$
   DECLARE 
   i_info_rest_id int;
  begin
	  i_info_rest_id := floor(random() * 900000) + 100000;
	 IF EXISTS (SELECT clientt_id FROM request_registration_rest WHERE clientt_id = i_id) then
	 	if exists (select info_rest_id from info_rest where info_rest_id=i_info_rest_id) then 
	 		update info_rest set info_rest_rating =  i_info_rest_raiting , info_rest_cuisine = i_info_rest_cuisine,
	 		info_rest_work_hours = i_info_rest_work_hours ,rest_itn=i_rest_itn ,rest_legal_address=i_rest_legal_address, 
	 		rest_bank_account = i_rest_bank_account ,mean_delivery_time=i_mean_delivery_time where restaurant_info = i_info_rest_id;
	 	else
	 		  INSERT INTO info_rest  (info_rest_id, info_rest_rating, info_rest_cuisine, info_rest_work_hours, rest_itn, rest_legal_address, rest_bank_account, mean_delivery_time)
   				VALUES (i_info_rest_id, i_info_rest_raiting, i_info_rest_cuisine, i_info_rest_work_hours, i_rest_itn, i_rest_legal_address, i_rest_bank_account, i_mean_delivery_time);
   		end if;
   		update request_registration_rest set restaurant_info = i_info_rest_id where clientt_id = i_id;
   	ELSE
       RAISE EXCEPTION 'Invalid id provided';
   END IF;
END;
$$ LANGUAGE plpgsql;

/*Эта функция добаляет адрес ресторана*/
create or replace function add_rest_address(
	i_id int,
	i_address char,
	i_geolocation char
) RETURNS VOID AS $$
DECLARE 
	i_address_id int;
begin
	i_address_id :=floor(random() * 900000) + 100000;
	IF EXISTS (SELECT clientt_id FROM request_registration_rest WHERE clientt_id = i_id) THEN
       IF EXISTS (SELECT rest_address_id FROM rest_address WHERE rest_address_id = i_address_id) then
       		update rest_address set rest_address_name = i_address, rest_geolocation = i_geolocation where rest_address_id = i_address_id;
       else 
       		insert into rest_address (rest_address_id, rest_address_name, rest_geolocation)
       		values (i_address_id, i_address, i_address_id);
       end if;
       update request_registration_rest set restaurant_address = i_address_id where clientt_id = i_id;
    ELSE
       RAISE EXCEPTION 'Invalid id provided';
    END IF;
END;
$$ LANGUAGE plpgsql;

/*Эта функция добаляет меню ресторана*/
CREATE OR REPLACE FUNCTION add_menu3 (
   i_menu_description char,
   i_id int
) RETURNS VOID AS $$
DECLARE 
   i_menu_id int;
BEGIN
   i_menu_id := floor(random() * 900000) + 100000;
   IF EXISTS (SELECT clientt_id FROM request_registration_rest WHERE clientt_id = i_id) THEN
       IF EXISTS (SELECT menu_id FROM menu WHERE menu_id = i_menu_id) THEN
           UPDATE menu SET menu_description = i_menu_description WHERE menu_id = i_menu_id;
       ELSE
           INSERT INTO menu (menu_id, menu_description) 
           VALUES (i_menu_id, i_menu_description);
       END IF;
       UPDATE request_registration_rest SET menu_id = i_menu_id WHERE clientt_id = i_id;
   ELSE
       RAISE EXCEPTION 'Invalid id provided';
   END IF;
END;
$$ LANGUAGE plpgsql;

/*Эта финальная функция которая добовляет ресторан. Она должна заолняться в самом конце*/
CREATE OR REPLACE FUNCTION add_rest(
 i_id int,
 rest_name char
) RETURNS VOID AS $$
 DECLARE 
   i_restaurant_id int;
   restaurant_info int;
   menu_id int;
   i_rest_address_id int;
 BEGIN
   i_restaurant_id := floor(random() * 900000) + 100000;
   SELECT rr.restaurant_info, rr.menu_id, rr.restaurant_address INTO restaurant_info, menu_id, i_rest_address_id  FROM request_registration_rest rr WHERE rr.clientt_id = i_id;
   IF restaurant_info IS NOT NULL AND menu_id IS NOT NULL THEN
       IF EXISTS (SELECT restaurant_id FROM restaurant WHERE restaurant_id = i_restaurant_id) THEN
         UPDATE restaurant 
         SET restaurant_name = rest_name, 
             info_rest_id = restaurant_info, 
             menu_id = menu_id,
             rest_address_id = i_rest_address_id
         WHERE restaurant_id = i_restaurant_id;
       ELSE 
          INSERT INTO restaurant (restaurant_id, restaurant_name, info_rest_id, menu_id, rest_address_id)
          VALUES (i_restaurant_id, rest_name, restaurant_info, menu_id, i_rest_address_id);
       END IF;
       UPDATE request_registration_rest 
       SET restaurant_id = i_restaurant_id 
       WHERE clientt_id = i_id;
     ELSE
       RAISE EXCEPTION 'Invalid id provided';
   END IF;
END;
$$ LANGUAGE plpgsql;





