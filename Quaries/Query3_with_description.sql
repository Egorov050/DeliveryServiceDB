WITH DishOrderTotals AS (
    select dc.dish_cat_name, o.creation_time, SUM(o.dish_quantity) AS daily_ordered_quantity, 
    SUM(SUM(o.dish_quantity)) OVER (PARTITION BY dc.dish_cat_name ORDER BY o.creation_time) AS running_total
    FROM
        dishes d
    JOIN
        dish_cat dc ON d.dish_cat_id = dc.dish_cat_id
    JOIN
        clientorder o ON d.dish_id = o.dish_id
    GROUP BY
        dc.dish_cat_name,
        o.creation_time
)
SELECT
    dish_cat_name,
    creation_time,
    daily_ordered_quantity,
    running_total
FROM
    DishOrderTotals
ORDER BY
    dish_cat_name,
    creation_time;
/*
funcitonality: The query is designed to retrieve information about the daily and cumulative quantities of dishes ordered, 
categorized by dish category and ordered by the creation time of the orders.
Who will use: Menu Planning Team: This query provides valuable insights into the popularity of different dish categories over time.
The menu planning team can use this data to adjust the menu by adding, modifying, or discontinuing certain categories of dishes based on 
their historical order quantities.
*/
