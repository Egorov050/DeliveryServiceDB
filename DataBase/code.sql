CREATE TABLE Address
(
  address_id INT NOT NULL,
  user_address CHAR(20) NOT NULL,
  PRIMARY KEY (address_id)
);

CREATE TABLE Client_type
(
  client_type_id INT NOT NULL,
  client_type_age_gap CHAR(20) NOT NULL,
  client_type_spending_gap CHAR(20) NOT NULL,
  client_type_sex CHAR(20) NOT NULL,
  PRIMARY KEY (client_type_id)
);

CREATE TABLE info_rest
(
  info_rest_id INT NOT NULL,
  info_rest_raiting INT NOT NULL,
  info_rest_cuisine CHAR(20) NOT NULL,
  info_rest_work_hours DATE NOT NULL,
  rest_itn INT NOT NULL,
  rest_legal_address CHAR(20) NOT NULL,
  rest_bank_account INT NOT NULL,
  mean_delivery_time INT NOT NULL,
  PRIMARY KEY (info_rest_id)
);

CREATE TABLE rest_address
(
  rest_address_id INT NOT NULL,
  rest_address_name CHAR(20) NOT NULL,
  rest_geolocation CHAR(20) NOT NULL,
  PRIMARY KEY (rest_address_id)
);

CREATE TABLE menu
(
  menu_id INT NOT NULL,
  menu_description CHAR(20) NOT NULL,
  PRIMARY KEY (menu_id)
);

CREATE TABLE dish_cat
(
  dish_cat_id INT NOT NULL,
  dish_cat_name CHAR(20) NOT NULL,
  dish_price_gap CHAR(20) NOT NULL,
  PRIMARY KEY (dish_cat_id)
);

CREATE TABLE sales
(
  sale_id INT NOT NULL,
  sale_name CHAR(20) NOT NULL,
  sale_start DATE NOT NULL,
  sale_end DATE NOT NULL,
  discount INT NOT NULL,
  PRIMARY KEY (sale_id)
);

CREATE TABLE Salary
(
  contract_id INT NOT NULL,
  salary_amount INT NOT NULL,
  contract_scan bytea NOT NULL,
  salary_bank_account INT NOT NULL,
  PRIMARY KEY (contract_id)
);

CREATE TABLE client_cards
(
  card_num INT NOT NULL,
  card_type CHAR(20) NOT NULL,
  card_ccv INT NOT NULL,
  card_date CHAR(20) NOT NULL,
  PRIMARY KEY (card_num)
);

CREATE TABLE work_belongings
(
  complect_id INT NOT NULL,
  jacket_num INT NOT NULL,
  box_num INT NOT NULL,
  PRIMARY KEY (complect_id)
);

CREATE TABLE payment_method
(
  method_id INT NOT NULL,
  method_type CHAR(20) NOT NULL,
  PRIMARY KEY (method_id)
);

CREATE TABLE issues
(
  issue_id INT NOT NULL,
  issue_description CHAR(20) NOT NULL,
  issue_name CHAR(20) NOT NULL,
  PRIMARY KEY (issue_id)
);

CREATE TABLE support_team
(
  employee_id INT NOT NULL,
  employee_name CHAR(20) NOT NULL,
  employee_surname CHAR(20) NOT NULL,
  email CHAR(20) NOT NULL,
  PRIMARY KEY (employee_id)
);

CREATE TABLE audit
(
  average_bill INT NOT NULL,
  orders_per_month INT NOT NULL,
  revenue INT NOT NULL,
  audit_id INT NOT NULL,
  most_popular_dish CHAR(20) NOT NULL,
  avg_customer_age INT NOT NULL,
  PRIMARY KEY (audit_id)
);

CREATE TABLE Client
(
  user_id INT NOT NULL,
  client_name CHAR(20) NOT NULL,
  client_surname CHAR(20) NOT NULL,
  client_phone INT NOT NULL,
  client_login CHAR(20) NOT NULL,
  client_password CHAR(20) NOT NULL,
  client_birthdate DATE NOT NULL,
  client_sex CHAR(20) NOT NULL,
  client_geolocation CHAR(20) NOT NULL,
  client_type_id INT NOT NULL,
  PRIMARY KEY (user_id),
  FOREIGN KEY (client_type_id) REFERENCES Client_type(client_type_id)
);

CREATE TABLE restaurant
(
  restaurant_id INT NOT NULL,
  restaurant_name CHAR(20) NOT NULL,
  info_rest_id INT NOT NULL,
  rest_address_id INT NOT NULL,
  menu_id INT NOT NULL,
  audit_id INT NOT NULL,
  PRIMARY KEY (restaurant_id),
  FOREIGN KEY (info_rest_id) REFERENCES info_rest(info_rest_id),
  FOREIGN KEY (rest_address_id) REFERENCES rest_address(rest_address_id),
  FOREIGN KEY (menu_id) REFERENCES menu(menu_id),
  FOREIGN KEY (audit_id) REFERENCES audit(audit_id)
);

CREATE TABLE dishes
(
  dish_id INT NOT NULL,
  dish_name CHAR(20) NOT NULL,
  dish_price INT NOT NULL,
  dish_description CHAR(20) NOT NULL,
  dish_weight INT NOT NULL,
  dish_pic bytea NOT NULL,
  dish_cat_id INT NOT NULL,
  sale_id INT NOT NULL,
  PRIMARY KEY (dish_id),
  FOREIGN KEY (dish_cat_id) REFERENCES dish_cat(dish_cat_id),
  FOREIGN KEY (sale_id) REFERENCES sales(sale_id)
);

create table request_registration_rest(
	clientt_id int primary key,
	statuse char,
	menu_id int,
	restaurant_id int,
	restaurant_info int,
	restaurant_address int,
	constraint add_address foreign key (restaurant_address) REFERENCES rest_address(rest_address_id),
	constraint add_menu foreign key (menu_id) REFERENCES menu(menu_id),
	constraint add_info foreign key (restaurant_info) REFERENCES info_rest(info_rest_id))
