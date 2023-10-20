select dishes.dish_name, dishes.dish_price, dishes.dish_description  
from dishes
join (select sale_id, discount from sales where discount > 60) DD
on dishes.sale_id = DD.sale_id;

/*
Functionality: The query retrieves information about dishes that are associated with sales that have a discount greater than 60%.
Who will use: Marketing Team: The marketing team can use the query to identify dishes on sale with substantial discounts. This information 
can be used in promotional materials, social media campaigns, or newsletters to attract customers to the restaurant.
*/
